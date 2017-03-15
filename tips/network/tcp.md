# ネットワーク - TCP


## インデックス
- [接続](#connect)
- [接続待機](#accept)
- [メッセージ送信](#send)
- [メッセージ受信](#receive)
- [名前解決して接続](#resolve)
- [タイムアウトを設定する](#timeout)


## <a name="connect" href="#connect">接続</a>
**同期バージョン**

同期バージョンの接続には、[`boost::asio::ip::tcp::socket`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__tcp/socket.html)クラスの[`connect`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_stream_socket/connect/overload2.html)()メンバ関数を使用する。

接続先の情報は`tcp::endpoint`に、IPアドレス文字列と、ポート番号の2つを指定する。

`connect()`の第2引数として`error_code`を渡した場合には、接続失敗時にエラー情報が`error_code`変数に格納される。

`error_code`を渡さなかった場合には、接続失敗時に`boost::system::system_error`が例外として投げられる。

```cpp
#include <iostream>
#include <boost/asio.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

int main()
{
    asio::io_service io_service;
    tcp::socket socket(io_service);

    boost::system::error_code error;
    socket.connect(tcp::endpoint(asio::ip::address::from_string("127.0.0.1"), 31400), error);

    if (error) {
        std::cout << "connect failed : " << error.message() << std::endl;
    }
    else {
        std::cout << "connected" << std::endl;
    }
}
```
* connect[color ff0000]


**非同期バージョン**

非同期バージョンの接続には、[`boost::asio::ip::tcp::socket`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__tcp/socket.html)クラスの[`async_connect`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_stream_socket/async_connect.html)`()`メンバ関数を使用する。

第1引数として、接続先情報のIPアドレス文字列と、ポート番号を指定する。

第2引数として、接続成功もしくは接続失敗時に呼ばれる関数を指定する。

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

class Client {
    asio::io_service& io_service_;
    tcp::socket socket_;

public:
    Client(asio::io_service& io_service)
        : io_service_(io_service),
          socket_(io_service)
    {}

    void connect()
    {
        socket_.async_connect(
                tcp::endpoint(asio::ip::address::from_string("127.0.0.1"), 31400),
                boost::bind(&Client::on_connect, this, asio::placeholders::error));
    }

    void on_connect(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "connect failed : " << error.message() << std::endl;
        }
        else {
            std::cout << "connected" << std::endl;
        }
    }
};

int main()
{
    asio::io_service io_service;
    Client client(io_service);

    client.connect();

    io_service.run();
}
```
* async_connect[color ff0000]


## <a name="accept" href="#accept">接続待機</a>
接続待機には、[`boost::asio::ip::tcp::acceptor`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__tcp/acceptor.html)クラスを使用する。

`acceptor`クラスのコンストラクタには、IPのバージョン(`tcp::v4()` or `tcp::v6()`)とポート番号を設定する。


**同期バージョン**

同期バージョンの接続待機には、`acceptor`クラスの[`accept`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_socket_acceptor/accept.html)`()`メンバ関数を使用する。

引数として、バインディングする`socket`クラスオブジェクトへの参照を渡す。

```cpp
#include <iostream>
#include <boost/asio.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

int main()
{
    asio::io_service io_service;

    tcp::acceptor acc(io_service, tcp::endpoint(tcp::v4(), 31400));
    tcp::socket socket(io_service);

    boost::system::error_code error;
    acc.accept(socket, error);

    if (error) {
        std::cout << "accept failed: " << error.message() << std::endl;
    }
    else {
        std::cout << "accept correct!" << std::endl;
    }
}
```
* tcp::acceptor[color ff0000]
* accept[color ff0000]


**非同期バージョン**

非同期バージョンの接続待機には、`acceptor`クラスの[`async_accept`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_socket_acceptor/async_accept/overload1.html)`()`メンバ関数を使用する。

第1引数としてバインディングする`socket`オブジェクトへの参照をとり、第2引数として接続成功もしくは接続失敗時に呼ばれる関数を指定する。

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

class Server {
    asio::io_service& io_service_;
    tcp::acceptor acceptor_;
    tcp::socket socket_;

public:
    Server(asio::io_service& io_service)
        : io_service_(io_service),
          acceptor_(io_service, tcp::endpoint(tcp::v4(), 31400)),
          socket_(io_service) {}

    void start_accept()
    {
        acceptor_.async_accept(
            socket_,
            boost::bind(&Server::on_accept, this, asio::placeholders::error));
    }

private:
    void on_accept(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "accept failed: " << error.message() << std::endl;
        }
        else {
            std::cout << "accept correct!" << std::endl;
        }
    }
};

int main()
{
    asio::io_service io_service;
    Server server(io_service);

    server.start_accept();

    io_service.run();
}
```
* async_accept[color ff0000]


## <a name="send" href="#send">メッセージ送信</a>
ここでは、TCPソケットでのメッセージ送信方法を解説する。


**同期バージョン**

同期バージョンのメッセージ送信には、[`boost::asio::write()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/write.html)フリー関数を使用する。

この関数には、多様なバージョンが提供されているが、ここでは基本的なものを紹介する。

- 第1引数 ： `socket`オブジェクトへの参照
- 第2引数 ： 送信バッファ
- 第3引数 ： 送信結果を格納するエラー値への参照(省略可)

第3引数を省略し、エラーが発生した場合は`boost::system::system_error`例外が投げられる。

```cpp
#include <iostream>
#include <boost/asio.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

int main()
{
    asio::io_service io_service;
    tcp::socket socket(io_service);

    // 接続
    socket.connect(tcp::endpoint(asio::ip::address::from_string("127.0.0.1"), 31400));

    // メッセージ送信
    const std::string msg = "ping";
    boost::system::error_code error;
    asio::write(socket, asio::buffer(msg), error);

    if (error) {
        std::cout << "send failed: " << error.message() << std::endl;
    }
    else {
        std::cout << "send correct!" << std::endl;
    }
}
```
* write[color ff0000]


**非同期バージョン**

非同期バージョンのメッセージ送信には、[`boost::asio::async_write()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/async_write.html)フリー関数を使用する。

この関数もまた、いくつかのバージョンが提供されているが、ここでは基本的なものを紹介する。

- 第1引数 ： `socket`オブジェクトへの参照
- 第2引数 ： 送信バッファ
- 第3引数 ： 送信成功もしくは失敗時に呼ばれる関数

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

class Client {
    asio::io_service& io_service_;
    tcp::socket socket_;
    std::string send_data_; // 送信データ

public:
    Client(asio::io_service& io_service)
        : io_service_(io_service),
          socket_(io_service)
    {}

    void start()
    {
        connect();
    }

private:
    // 接続
    void connect()
    {
        socket_.async_connect(
                tcp::endpoint(asio::ip::address::from_string("127.0.0.1"), 31400),
                boost::bind(&Client::on_connect, this, asio::placeholders::error));
    }

    // 接続完了
    void on_connect(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "connect failed : " << error.message() << std::endl;
            return;
        }

        send();
    }

    // メッセージ送信
    void send()
    {
        send_data_ = "ping";
        asio::async_write(
                socket_,
                asio::buffer(send_data_),
                boost::bind(&Client::on_send, this,
                            asio::placeholders::error,
                            asio::placeholders::bytes_transferred));
    }

    // 送信完了
    // error : エラー情報
    // bytes_transferred : 送信したバイト数
    void on_send(const boost::system::error_code& error, size_t bytes_transferred)
    {
        if (error) {
            std::cout << "send failed: " << error.message() << std::endl;
        }
        else {
            std::cout << "send correct!" << std::endl;
        }
    }
};

int main()
{
    asio::io_service io_service;
    Client client(io_service);

    client.start();

    io_service.run();
}
```
* async_write[color ff0000]


## <a name="receive" href="#receive">メッセージ受信</a>

ここでは、TCPソケットでのメッセージ受信の方法を解説する。


**同期バージョン**

同期バージョンのメッセージ受信には、以下のいずれかの関数を使用する。

- [`boost::asio::read()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/read.html) ： 指定したバイト数もしくは全データを受信する
- [`boost::asio::read_at()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/read_at.html) ： 指定した位置のデータを受信する
- [`boost::asio::read_until()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/read_until.html) ： 指定したパターンのデータまで受信する(特定文字列もしくは正規表現)

ここでは、[`boost::asio::read()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/read.html)フリー関数を使用して解説する。

- 第1引数 ： `sockeオブジェクト`への参照
- 第2引数 ： 受信バッファへの参照
- 第3引数 ： どれくらい受信するか。[`transfer_all()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_all.html)はバッファがいっぱいになるまで読む。[`transfer_at_least(size_t minimum)`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_at_least.html)は最低でもNバイト読む。[`transfer_exactly(size_t size)`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_exactly.html)は指定したサイズ読む。
- 第4引数 ： 受信結果を格納するエラー値への参照(省略可)

第4引数を省略し、エラーが発生した場合は`boost::system::system_error`例外が投げられる。

```cpp
#include <iostream>
#include <boost/asio.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

int main()
{
    asio::io_service io_service;

    tcp::acceptor acc(io_service, tcp::endpoint(tcp::v4(), 31400));
    tcp::socket socket(io_service);

    // 接続待機
    acc.accept(socket);

    // メッセージ受信
    asio::streambuf receive_buffer;
    boost::system::error_code error;
    asio::read(socket, receive_buffer, asio::transfer_all(), error);

    if (error && error != asio::error::eof) {
        std::cout << "receive failed: " << error.message() << std::endl;
    }
    else {
        const char* data = asio::buffer_cast<const char*>(receive_buffer.data());
        std::cout << data << std::endl;
    }
}
```
* read(socket, receive_buffer, asio::transfer_all(), error);[color ff0000]


**非同期バージョン**

非同期バージョンのメッセージ受信には、以下のいずれかの関数を使用する。

- [`boost::asio::async_read()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/async_read.html) ： 指定したバイト数もしくは全データを受信する
- [`boost::asio::async_read_at()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/async_read_at.html) ： 指定した位置のデータを受信する
- [`boost::asio::async_read_until()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/async_read_until.html) ： 指定したパターンのデータまで受信する(特定文字列もしくは正規表現)
ここでは、[`boost::asio::async_read()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/async_read.html)フリー関数を使用して解説する。

- 第1引数 ： `socket`オブジェクトへの参照
- 第2引数 ： 受信バッファへの参照
- 第3引数 ： どれくらい受信するか。[`transfer_all()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_all.html)はバッファがいっぱいになるまで読む。[`transfer_at_least(size_t minimum)`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_at_least.html)は最低でもNバイト読む。[`transfer_exactly(size_t size)`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/transfer_exactly.html)は指定したサイズ読む。
- 第4引数 ： 受信成功もしくは失敗時に呼ばれる関数

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/bind.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

class Server {
    asio::io_service& io_service_;
    tcp::acceptor acceptor_;
    tcp::socket socket_;
    asio::streambuf receive_buff_;

public:
    Server(asio::io_service& io_service)
        : io_service_(io_service),
          acceptor_(io_service, tcp::endpoint(tcp::v4(), 31400)),
          socket_(io_service) {}

    void start()
    {
        start_accept();
    }

private:
    // 接続待機
    void start_accept()
    {
        acceptor_.async_accept(
            socket_,
            boost::bind(&Server::on_accept, this, asio::placeholders::error));
    }

    // 接続待機完了
    void on_accept(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "accept failed: " << error.message() << std::endl;
            return;
        }

        start_receive();
    }

    // メッセージ受信
    void start_receive()
    {
        boost::asio::async_read(
            socket_,
            receive_buff_,
            asio::transfer_all(),
            boost::bind(&Server::on_receive, this,
                        asio::placeholders::error, asio::placeholders::bytes_transferred));
    }

    // 受信完了
    // error : エラー情報
    // bytes_transferred : 受信したバイト数
    void on_receive(const boost::system::error_code& error, size_t bytes_transferred)
    {
        if (error && error != boost::asio::error::eof) {
            std::cout << "receive failed: " << error.message() << std::endl;
        }
        else {
            const char* data = asio::buffer_cast<const char*>(receive_buff_.data());
            std::cout << data << std::endl;

            receive_buff_.consume(receive_buff_.size());
        }
    }
};

int main()
{
    asio::io_service io_service;
    Server server(io_service);

    server.start();

    io_service.run();
}
```
* async_read[color ff0000]


## <a name="resolve" href="#resolve">名前解決して接続</a>
名前解決には、[`boost::asio::ip::tcp::resolver`](http://www.boost.org/doc/libs/rerlease/doc/html/boost_asio/reference/ip__tcp/resolver.html)クラスと[`boost::asio::ip::tcp::resolver::query`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__basic_resolver/query.html)クラスを組み合わせて使用する。

`query`クラスのコンストラクタには、以下を指定する：

- 第1引数 ： ホスト名
- 第2引数 ： サービス名


**同期バージョン**

ホスト名等が設定された`query`オブジェクトを`resolver`クラスの`resolve()`メンバ関数に渡し、その文字列を接続関数に渡すことで、同期バージョンでの名前解決しての接続ができる。

この関数の最後の引数として`boost::system::error_code`オブジェクトへの参照を渡した場合には、名前解決失敗時にエラー情報が格納される。`error_code`を渡さなかった場合には、名前解決失敗時に`boost::system::system_error`が例外として投げられる。

また、この関数は戻り値として、[`boost::asio::ip::tcp::resolver::iterator`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__basic_resolver/iterator.html)オブジェクトを返す。このイテレータは、デフォルト構築されたイテレータを終端としてイテレートできる。このイテレータは間接参照によって[`endpoint`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__tcp/endpoint.html)オブジェクトが取得できる。

```cpp
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <iostream>

namespace asio = boost::asio;
using asio::ip::tcp;

class Client {
    asio::io_service& io_service_;
    tcp::socket socket_;

public:
    Client(asio::io_service& io_service)
        : io_service_(io_service),
          socket_(io_service)
    {
    }

    void connect()
    {
        tcp::resolver resolver(io_service_);
        tcp::resolver::query query("google.com", "http");

        // 同期で名前解決
        // 非同期で接続
        asio::async_connect(
            socket,
            resolver_.resolve(query),
            boost::bind(&Client::on_connect, this, asio::placeholders::error));
    }

private:
    void on_connect(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "connect error : " << error.message() << std::endl;
        }
        else {
            std::cout << "connect!" << std::endl;
        }
    }
};

int main()
{
    asio::io_service io_service;

    Client client(io_service);
    client.connect();

    io_service.run();
}
```
* query("google.com", "http")[color ff0000]
* resolve[color ff0000]


**非同期バージョン**

非同期バージョンの名前解決には、[boost::asio::ip::tcp::resolver](http://www.boost.org/doc/libs/rerlease/doc/html/boost_asio/reference/ip__tcp/resolver.html)クラスの[`async_resolve`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__basic_resolver/async_resolve/overload1.html)`()`メンバ関数を使用する。

- 第1引数 ： `query`オブジェクト
- 第2引数 ： 名前解決の成功もしくは失敗時に呼ばれる関数。iteratorプレースホルダを束縛することにより、完了時に呼ばれる関数に、`endpoint`のイテレータが渡される。

```cpp
#include <boost/asio.hpp>
#include <boost/bind.hpp>
#include <iostream>

namespace asio = boost::asio;
using asio::ip::tcp;

class Client {
    asio::io_service& io_service_;
    tcp::socket socket_;
    tcp::resolver resolver_;

public:
    Client(asio::io_service& io_service)
        : io_service_(io_service),
          socket_(io_service),
          resolver_(io_service)
    {
    }

    void connect()
    {
        tcp::resolver::query query("google.com", "http");

        // 非同期で名前解決
        resolver_.async_resolve(
            query,
            boost::bind(&Client::on_resolve, this,
                        asio::placeholders::error,
                        asio::placeholders::iterator));
    }

private:
    void on_resolve(const boost::system::error_code& error,
                    tcp::resolver::iterator endpoint_iterator)
    {
        if (error) {
            std::cout << "resolve failed: " << error.message() << std::endl;
            return;
        }

        // 非同期で接続
        asio::async_connect(
            socket_,
            endpoint_iterator,
            boost::bind(&Client::on_connect, this, asio::placeholders::error));
    }

    void on_connect(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "connect error : " << error.message() << std::endl;
        }
        else {
            std::cout << "connect!" << std::endl;
        }
    }
};

int main()
{
    asio::io_service io_service;

    Client client(io_service);
    client.connect();

    io_service.run();
}
```
* async_resolve[color ff0000]


## <a name="timeout" href="#timeout">タイムアウトを設定する</a>
通信処理のタイムアウトには、ソケットに対してタイムアウトを指定するのではなく、タイマークラスの非同期イベントと組み合わせて行う。

同期通信でタイムアウトを指定する方法はないため、ここでは非同期バージョンのみ示す。

```cpp
#include <iostream>
#include <boost/asio.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/bind.hpp>

namespace asio = boost::asio;
using asio::ip::tcp;

class Client {
    asio::io_service& io_service_;
    tcp::socket socket_;
    asio::streambuf receive_buff_;

    asio::steady_timer timer_; // タイムアウト用のタイマー
    bool is_canceled_;

public:
    Client(asio::io_service& io_service)
        : io_service_(io_service),
          socket_(io_service),
          timer_(io_service),
          is_canceled_(false)
    {}

    void start()
    {
        connect();
    }

private:
    // 接続
    void connect()
    {
        socket_.async_connect(
                tcp::endpoint(asio::ip::address::from_string("127.0.0.1"), 31400),
                boost::bind(&Client::on_connect, this, asio::placeholders::error));
    }

    // 接続完了
    void on_connect(const boost::system::error_code& error)
    {
        if (error) {
            std::cout << "connect failed : " << error.message() << std::endl;
            return;
        }

        start_receive();
    }

    // メッセージ送信
    void start_receive()
    {
        boost::asio::async_read(
            socket_,
            receive_buff_,
            asio::transfer_all(),
            boost::bind(&Client::on_receive, this,
                        asio::placeholders::error, asio::placeholders::bytes_transferred));

        // 5秒でタイムアウト
        timer_.expires_from_now(boost::chrono::seconds(5));
        timer_.async_wait(boost::bind(&Client::on_timer, this, _1));
    }

    // 受信完了
    // error : エラー情報
    // bytes_transferred : 送信したバイト数
    void on_receive(const boost::system::error_code& error, size_t bytes_transferred)
    {
        if (error == asio::error::operation_aborted) {
            std::cout << "タイムアウト" << std::endl;
        }
        else {
            // タイムアウトになる前に処理が正常終了したのでタイマーを切る
            // タイマーのハンドラにエラーが渡される
            timer_.cancel();
            is_canceled_ = true;

            if (error) {
                std::cout << "その他のエラー : " << error.message() << std::endl;
            }
            else {
                std::cout << "受信成功" << std::endl;
            }
        }
    }

    // タイマーのイベント受信
    void on_timer(const boost::system::error_code& error) {
        if (!error && !is_canceled_) {
            socket_.cancel(); // 通信処理をキャンセルする。受信ハンドラがエラーになる
        }
    }
};

int main()
{
    asio::io_service io_service;
    Client client(io_service);

    client.start();

    io_service.run();
}
```
* asio::steady_timer[color ff0000]
* expires_from_now[color ff0000]
* async_wait[color ff0000]
* operation_aborted[color ff0000]
* cancel[color ff0000]


タイムアウトにはいくつかのポイントがある。

**1. タイマークラスの選択**

タイマークラスには以下の選択肢がある：

| タイマークラス | 説明 |
|-----------------------------------------------------------|----------------------------------------------------------|
| [`boost::asio::deadline_timer`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/deadline_timer.html) | Boost.DateTimeライブラリの`posix_time`で時間指定を行う古いタイマー |
| [`boost::asio::high_resolution_timer`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/high_resolution_timer.html) | 高分解能タイマー |
| [`boost::asio::steady_timer`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/steady_timer.html) | 時間が逆行しないことを保証するタイマー |
| [`boost::asio::system_timer`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/system_timer.html) | `time_t`と互換性のあるタイマー |

用途に応じて使い分ける必要があるが、基本的には`steady_timer`を推奨する。これは、タイマー処理中にOSの時間設定が変更されても時間が逆行しないタイマーであるため、外部要因によるバグを防ぐことができる。


**2. タイムアウトの時間設定**

タイムアウトの時間指定は、ここでは以下のように行なっている：

```cpp
// 5秒でタイムアウト
timer_.expires_from_now(boost::chrono::seconds(5));
timer_.async_wait(boost::bind(&Client::on_timer, this, _1));
```

各タイマークラスの[`expires_from_now()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_waitable_timer/expires_from_now/overload2.html)メンバ関数は、現在日時からの相対時間でタイムアウトを指定する関数である。特定の日時にタイムアウトを設定したい場合は、[`expires_at()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_waitable_timer/expires_at/overload2.html)メンバ関数を使用する。


**3. タイムアウト方法**

ここまではタイムアウトではなく、単にタイマーの使い方を見てきた。
実際のタイムアウトは以下のようにして行う：

1. タイマーハンドラで通信処理をキャンセル or 失敗させる。

通信処理が正常終了するより前にタイマーハンドラが呼ばれたら、[`socket`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/ip__tcp/socket.html)クラスの[`cancel()`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/basic_stream_socket/cancel/overload1.html)メンバ関数や`close()`メンバ関数を使用して通信処理を異常終了させる。

```cpp
// タイマーのイベント受信
void on_timer(const boost::system::error_code& error) {
    if (!error && !is_canceled_) {
        socket_.cancel(); // 通信処理をキャンセルする。受信ハンドラがエラーになる
    }
}
```

注意すべきポイントは、これらの異常終了させるための関数を呼び出しても、通信処理のイベントハンドラが呼び出されるということである。


2. 通信処理のイベントハンドラでタイムアウトによる中断をハンドリングする

タイムアウトによって通信処理が異常終了した場合、通信処理のイベントハンドラには[`boost::asio::error::operation_aborted`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/error__basic_errors.html)というエラーが渡される。ハンドラは、タイムアウトによって失敗したのかどうかを正しくハンドリングする必要がある。

```cpp
void on_receive(const boost::system::error_code& error, size_t bytes_transferred)
{
    if (error == asio::error::operation_aborted) {
        std::cout << "タイムアウト" << std::endl;
    }

    ...
}
```

3. 通信処理がタイマーよりも早く正常終了したらタイマーをキャンセルする

通信処理がタイムアウトを待つことなく正常終了した場合は、タイマーを止める必要がある。これをしないと以降の通信処理が意図せずタイムアウトになってしまうだろう。

```cpp
if (error == asio::error::operation_aborted) {
    std::cout << "タイムアウト" << std::endl;
}
else {
    // タイムアウトになる前に処理が正常終了したのでタイマーを切る
    // タイマーのハンドラにエラーが渡される
    timer_.cancel();
    is_canceled_ = true;
}
```

タイマークラスの`calcel()`メンバ関数を呼ぶと、`socket`の場合と逆に、タイマーのハンドラに[`boost::asio::error::operation_aborted`](http://www.boost.org/doc/libs/release/doc/html/boost_asio/reference/error__basic_errors.html)エラーが渡されることになる。

ただし、`cancel()`メンバ関数を呼ぶ直前ですでにタイムアウトになっている場合、`boost::asio::error::operation_aborted`エラーがハンドラに渡されない可能性がある。
この場合に備えてフラグ変数等でタイマーを止めたことを知らせる必要がある。

documented boost version is 1.51.0
