buildscript {
    repositories {
        google()  
        mavenCentral()
    }
    dependencies {
        classpath("com.google.gms:google-services:4.3.15") // ✅ Google Services plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0") // ✅ Add Kotlin Plugin
    }
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
    
    // 🔥 Force stable versions project-wide to bypass AGP 8.9.1 requirement
    configurations.all {
        resolutionStrategy {
            force("androidx.core:core:1.13.1")
            force("androidx.core:core-ktx:1.13.1")
            force("androidx.browser:browser:1.8.0")
            force("androidx.activity:activity:1.9.1")
            force("androidx.fragment:fragment:1.8.0")
            force("androidx.navigation:navigation-common:2.7.7")
            force("androidx.navigation:navigation-runtime:2.7.7")
            force("androidx.navigation:navigation-fragment:2.7.7")
            force("androidx.navigation:navigation-ui:2.7.7")
            force("androidx.lifecycle:lifecycle-runtime:2.7.0")
            force("androidx.lifecycle:lifecycle-viewmodel:2.7.0")
            force("androidx.lifecycle:lifecycle-common:2.7.0")
        }
    }
}

// 🔥 Global fix for AGP 8.0 namespace requirement in older plugins
subprojects {
    afterEvaluate {
        if (hasProperty("android")) {
            val android = extensions.getByName("android") as com.android.build.gradle.BaseExtension
            if (android.namespace == null) {
                android.namespace = "com.roi_app.${project.name.replace("-", ".")}"
            }
        }
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
