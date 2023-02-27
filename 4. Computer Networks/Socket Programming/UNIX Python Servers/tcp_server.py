#!/usr/bin/env python3

import socket

from os import fork, _exit, waitpid
from multiprocessing import Process
from threading import Thread


IP = "0.0.0.0"
PORT = 7777
ADDR = (IP, PORT)

SOCK_BACKLOG = 8
INT_BYTES = 4

threads = list()
processes = list()
forks = list()


def worker(cs) -> None:
    received_bytes = cs.recv(INT_BYTES)
    number = int.from_bytes(received_bytes, byteorder="big", signed=False)
    print(f"Got: {number}")

    to_send = number * 2
    cs.send(to_send.to_bytes(INT_BYTES, byteorder="big", signed=False))
    print(f"Sent: {to_send}")

    # Need to shut down because this may be
    # a different process. If this were a thread,
    # then closing the socket would be enough.
    cs.shutdown(socket.SHUT_RDWR)


def process_on_thread(cs) -> None:
    t = Thread(target=worker, args=(cs,))
    threads.append(t)
    t.start()


def process_on_process(cs) -> None:
    p = Process(target=worker, args=(cs,))
    processes.append(p)
    p.start()


def process_on_fork(cs) -> None:
    pid = fork()
    # only execute code in the child process
    # call os._exit(0) to exit child process
    if pid == 0:
        worker(cs)
        _exit(0)
    else:
        forks.append(pid)


def main() -> None:
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    # do this before bind so that we can reuse
    # the port in case the program crashes
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    sock.bind(ADDR)
    sock.listen(SOCK_BACKLOG)
    print(f"Listening on {PORT}...")

    try:
        while True:
            cs, addr = sock.accept()
            print(f"Connected to {addr}")

            process_on_fork(cs)
            # process_on_process(cs)
            # process_on_thread(cs)

    except KeyboardInterrupt:
        print("\rStopping...")

    for t in threads:
        t.join()

    for p in processes:
        p.join()

    for pid in forks:
        waitpid(pid, 0)

    sock.close()
    print("Socket closed")


if __name__ == "__main__":
    main()
