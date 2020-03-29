defmodule ApiBankingWeb.AccountControllerTest do
  use ApiBankingWeb.ConnCase, async: true

    alias ApiBanking.AccountFactory
  alias ApiBanking.Accounts
  alias ApiBanking.Auth.GuardianAccount
  alias Decimal

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "accounts auth" do
    test "sign_in/2 returns the account id and token access", %{conn: conn} do
      account = AccountFactory.insert(:account)

      conn =
        post(conn, Routes.account_path(conn, :sign_in), %{
          "account_id" => account.id,
          "password" => "12345678"
        })

      response = json_response(conn, 200)["data"]

      assert Map.has_key?(response, "access_token")
    end

    test "sign_out/2 revoke token access", %{conn: conn} do
      account = AccountFactory.insert(:account)

      {:ok, token, _} = GuardianAccount.encode_and_sign(account, %{}, token_type: :access)

      response_conn =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :sign_out))

      assert Map.get(response_conn, :status) == 204

      conn =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :sign_out))

      assert Map.get(conn, :status) == 401
    end
  end

  describe "account transactions" do
    test "transfer/2 move money from actual account to target account", %{conn: conn} do
      accounts = AccountFactory.insert_list(2, :account)

      [
        %Accounts.Account{
          id: emitter_id,
          balance: emitter_balance
        },
        %Accounts.Account{
          id: receiver_id,
          balance: receiver_balance
        }
      ] = accounts

      emitter = hd(accounts)
      {:ok, token, _} = GuardianAccount.encode_and_sign(emitter, %{}, token_type: :access)
      amount = Decimal.from_float(122.44512345)

      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> post(Routes.account_path(conn, :transfer), %{
        "transfer_to" => receiver_id,
        "amount" => amount
      })

      emitter_updated = Accounts.get_account!(emitter_id)
      receiver_updated = Accounts.get_account!(receiver_id)

      assert Decimal.sub(emitter_balance, amount) == emitter_updated.balance
      assert Decimal.add(receiver_balance, amount) == receiver_updated.balance
    end

    test "transfer/2 with greater than 1000", %{conn: conn} do
      accounts = AccountFactory.insert_list(2, :account)

      [
        %Accounts.Account{
          id: emitter_id,
          balance: emitter_balance
        },
        %Accounts.Account{
          id: receiver_id,
          balance: receiver_balance
        }
      ] = accounts

      emitter = hd(accounts)
      {:ok, token, _} = GuardianAccount.encode_and_sign(emitter, %{}, token_type: :access)
      amount = 1233

      transfer_req =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :transfer), %{
          "transfer_to" => receiver_id,
          "amount" => amount
        })

      assert transfer_req.status == 422

      emitter_updated = Accounts.get_account!(emitter_id)
      receiver_updated = Accounts.get_account!(receiver_id)

      assert emitter_updated.balance != Decimal.sub(emitter_balance, amount)
      assert receiver_updated.balance != Decimal.add(receiver_balance, amount)
    end

    test "transfer/2 with same id", %{conn: conn} do
      account = AccountFactory.insert(:account)

      %Accounts.Account{
        id: account_id
      } = account

      {:ok, token, _} = GuardianAccount.encode_and_sign(account, %{}, token_type: :access)
      amount = 1233

      transfer_req =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :transfer), %{
          "transfer_to" => account_id,
          "amount" => amount
        })

      assert transfer_req.status == 422
    end

    test "transfer/2 until balance become negative", %{conn: conn} do
      accounts = AccountFactory.insert_list(2, :account)

      [
        %Accounts.Account{
          id: emitter_id
        },
        %Accounts.Account{
          id: receiver_id
        }
      ] = accounts

      emitter = hd(accounts)
      {:ok, token, _} = GuardianAccount.encode_and_sign(emitter, %{}, token_type: :access)

      transfer_until_become_negative(conn, emitter_id, receiver_id, token)
    end

    test "withdraw/2 remove money from account", %{conn: conn} do
      account = AccountFactory.insert(:account)
      amount = :random.uniform(1000)
      {:ok, token, _} = GuardianAccount.encode_and_sign(account, %{}, token_type: :access)

      conn
      |> put_req_header("authorization", "bearer " <> token)
      |> post(Routes.account_path(conn, :withdraw), %{
        "amount" => amount
      })

        assert Decimal.sub(account.balance, amount) == Map.get(Accounts.get_account!(account.id), :balance)
    end

    test "withdraw/2 negative value", %{conn: conn} do
      account = AccountFactory.insert(:account)
      amount = -:random.uniform(1000)
      {:ok, token, _} = GuardianAccount.encode_and_sign(account, %{}, token_type: :access)

      withdraw_req =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :withdraw), %{
          "amount" => amount
        })

      assert withdraw_req.status == 422
    end

    test "withdraw/2 until balance become negative", %{conn: conn} do
      account = AccountFactory.insert(:account)

      {:ok, token, _} = GuardianAccount.encode_and_sign(account, %{}, token_type: :access)
      withdraw_until_become_negative(conn, account.id, token)
    end

    defp withdraw_until_become_negative(conn, account_id, token) do
      amount = :rand.uniform(200)
      account = Accounts.get_account!(account_id)

      balance_signal =
        Decimal.sub(account.balance, amount)
        |> Decimal.cmp(0)

      withdraw_req =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :withdraw), %{
          "amount" => amount
        })

      case balance_signal do
        :gt ->
          assert withdraw_req.status == 200
          withdraw_until_become_negative(conn, account_id, token)
        :eq ->
          assert withdraw_req.status == 200
          withdraw_until_become_negative(conn, account_id, token)
        :lt -> assert withdraw_req.status == 422
      end
    end

    defp transfer_until_become_negative(conn, emitter_id, receiver_id, token) do
      amount = :rand.uniform(200)
      emitter = Accounts.get_account!(emitter_id)

      balance_signal =
        Decimal.sub(emitter.balance, amount)
        |> Decimal.cmp(0)

      transfer_req =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :transfer), %{
          "transfer_to" => receiver_id,
          "amount" => amount
        })

      case balance_signal do
        :gt ->
          assert transfer_req.status == 200
          transfer_until_become_negative(conn, emitter_id, receiver_id, token)
        :eq ->
          assert transfer_req.status == 200
          transfer_until_become_negative(conn, emitter_id, receiver_id, token)
        :lt -> assert transfer_req.status == 422
      end
    end
  end
end
