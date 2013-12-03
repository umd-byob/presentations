from ruffus import *
from ruffus_example_utils import * 

input_file = 'example2.input'
if not exists(input_file):
    touch(input_file)

@files(input_file, ['A.task1', 'B.task1', 'C.task1', 'D.task1'])
def task1(inputs, outputs):
    printInfo('task1', inputs, outputs)
    createFiles(outputs)

task2_jobs = [ ['A.task1', '1.task2'],
               ['B.task1', '2.task2'],
               ['C.task1', ['3.task2', '4.task2']],
               ['D.task1', ['5.task2'] ]
             ]

@follows(task1)
@files(task2_jobs)
def task2(inputs, outputs):
    printInfo('task2', inputs, outputs)
    createFiles(outputs)

pipeline_printout(sys.stdout, [task2], )
pipeline_run([task2], multiprocess=4)