Measure-Command {
    git checkout -b feature/performance-test
    echo "#File1" > file-1.md
    echo "#File2" > file-2.md
    git status
    git add .
    git commit -m "this is a performance test commit" --no-verify
    git push -u origin feature/performance-test
}