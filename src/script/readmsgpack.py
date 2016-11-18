"""
Read a messagepack file
"""
import umsgpack
import sys

def read(file_name):
    with open(file_name, "rb") as IN:
        content = umsgpack.unpack(IN)
    return content


def main(args):
    f_in = args[0]
    content = read(f_in)
    print(content)

if __name__ == '__main__':
    main(sys.argv[1:])
