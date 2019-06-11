import sys


def progress_bar(progress, length):
    bar_length = 78
    prog_pcnt = float(progress)/float(length)
    bar_fill = int(bar_length * prog_pcnt)
    space_fill = bar_length - bar_fill
    fill = '#'*bar_fill + '\u001b[0m' + '-'*space_fill
    bar = '\r[\u001b[32m' + fill + ']\n' + str(progress) + ' of ' + str(length)
    print('\033[2A')
    print(bar, end='', flush=True)


if __name__ == '__main__':
    try:
        progress_bar(sys.argv[1],sys.argv[2])
    except IndexError:
        print("Usage: " + sys.argv[0] + '[number finished] [total amount]')

