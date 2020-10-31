$amount_of_projects = 2
$amount_of_directories = 5
$amount_of_subdirectories = 0
$amount_of_files_per_directory = 5

function AddFiles {
    param (
        $ProjectId,
        $DirectoryId = "/",
        $SubdirectoryId = "/"        
    )
    $path = "./project-$ProjectId"
    if ($DirectoryId -ne "/") {
        $path += "/directory-$DirectoryId"
    }

    if ($SubdirectoryId -ne "/") {
        $path += "/subdirectory-$SubdirectoryId"
    }

    for ($i = 0; $i -lt $amount_of_files_per_directory; $i++) {
        $fileName = "file-$i.md" 
        $value = [String](Get-Content './file-template.md').replace("#PROJECT", "project-$ProjectId`n").replace("#DIRECTORY", "$DirectoryId`n").replace("#SUBDIRECTORY", "$SubdirectoryId`n").replace("#FILE", "file-$i")
        New-Item -Path $Path -Name $fileName -ItemType "file" -Value $value.ToString() -Force
    } 
}


for ($i = 0; $i -lt $amount_of_projects; $i++) {
    $release_counter_of_project = 1

    Write-Output "Generate new Project project-$i"

    AddFiles -ProjectId $i

    git add . 
    git commit -m "add root files for project project-$i"
    git tag -a "project-$i-v$release_counter_of_project" -m "Release of project-$i-v$release_counter_of_project"
    # git push 

    $release_counter_of_project++

    for ($j = 0; $j -lt $amount_of_directories; $j++) {
        Write-Output "Generate Directory directory-$j for project-$i"

        AddFiles -ProjectId $i -DirectoryId $j

        git add . 
        git commit -m "add files for directory-$j in project-$i"
        # git push

        $commit_counter_of_project++

        for ($k = 0; $k -lt $amount_of_subdirectories; $k++) {
            Write-Output "Generate Sub-Directory subdirectory-$k in directory-$j for project-$i"

            AddFiles -ProjectId $i -DirectoryId $j -SubdirectoryId $k

            git add . 
            git commit -m "add files for subdirectory-$k in directory-$j in project-$i"
            # git push

            $commit_counter_of_project++
        }

        git tag -a "project-$i-v$release_counter_of_project" -m "Release of project-$i-v$release_counter_of_project"
        # git push  

        $release_counter_of_project++
    }
}
