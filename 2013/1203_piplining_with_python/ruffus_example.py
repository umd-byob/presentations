from ruffus import *
from ruffus_example_utils import *

input_file = 'example1.input'
if not exists(input_file):
    touch(input_file)

@files(input_file, 'A.task1')
def task1(inputs, outputs):
    printInfo('task1', inputs, outputs)
    createFiles(outputs)

@follows(task1)
@files('A.task1', '1.task2')
def task2(inputs, outputs):
    printInfo('task2', inputs, outputs)
    createFiles(outputs)

pipeline_printout(sys.stdout, [task2])
pipeline_run([task2])