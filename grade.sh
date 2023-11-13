CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point
file=`find student-submission -name "*.java"`
if ! [[ -f $file ]]
then
    echo "No java file submitted"
    exit
fi

filesToCopy=`find *.java student-submission/*.java`
cp $filesToCopy grading-area
cp -r lib grading-area

cd grading-area
javac -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar *.java 2> error.txt
if [[ $? != 0 ]] 
then 
    echo "Error Code $?: `cat error.txt`"
    exit
fi

java -cp .:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar org.junit.runner.JUnitCore TestListExamples > tests.txt

testString=`grep "Failures" tests.txt`
runString=${testString%%,*}
failString=${testString#*,}
echo $runString > tests.txt
totalRun=`grep -Eo '[0-9]{1,}' tests.txt`
echo $failString > tests.txt
totalFailed=`grep -Eo '[0-9]{1,}' tests.txt`
let totalPassed=$totalRun-$totalFailed
echo "Score: $totalPassed / $totalRun"

# Then, add here code to compile and run, and do any post-processing of the
# tests
