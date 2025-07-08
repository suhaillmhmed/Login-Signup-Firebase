buildscript{ 
    ext.kotlin_version = '1.3.50'
    repositories{
        google()
        mavenCentral()
    }

        dependencies {
            classpath 'com.android.tools.build:gradle:4.1.0'
            classpath "org.jetbrains.kotlin:kotlin-gradle:$kotlin_version"
            id("com.google.gms.google-services") version "4.4.3" apply false
        }
  
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects { 
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
