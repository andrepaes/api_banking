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

      conn =
        conn
        |> put_req_header("authorization", "bearer " <> token)
        |> post(Routes.account_path(conn, :sign_out))

      assert Map.get(conn, :status) == 204

      conn =
        conn
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

      for _i <- 1..10 do
        amount = :rand.uniform(100)

        transfer_req =
          conn
          |> put_req_header("authorization", "bearer " <> token)
          |> post(Routes.account_path(conn, :transfer), %{
            "transfer_to" => receiver_id,
            "amount" => amount
          })

        emitter_updated = Accounts.get_account!(emitter_id)

        is_balance_allowed? =
          Decimal.sub(emitter_updated.balance, amount)
          |> Decimal.cmp(0)

        case is_balance_allowed? do
          :gt -> assert transfer_req.status == 200
          :eq -> assert transfer_req.status == 200
          :lt -> assert transfer_req.status == 422
        end
      end
    end
  end
end
