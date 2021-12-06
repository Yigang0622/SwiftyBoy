from typedef import *


def write_swift_cpu_file(file: CPUExtensionSwiftFile):
    with open(file.name, 'w') as f:
        print('Writing {}'.format(file.name))
        f.write(str(file))
