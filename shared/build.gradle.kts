plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
}

val frameworkVersion = "1.0.0"
var frameworkName = "SharedLibrary"

kotlin {
    androidTarget {
        compilations.all {
            kotlinOptions {
                jvmTarget = "1.8"
            }
        }
    }
    
    listOf(
        iosX64 {binaries.framework(frameworkName) },
        iosArm64 { binaries.framework(frameworkName) },
        iosSimulatorArm64()
    ).forEach {
        it.binaries.framework {
            baseName = "shared"
            isStatic = true
        }
    }

    sourceSets {
        commonMain.dependencies {
            //put your multiplatform dependencies here
        }
        commonTest.dependencies {
            implementation(libs.kotlin.test)
        }
    }

    tasks {
        val iosFrameworkName = frameworkName

        register("universalFrameworkDebug", org.jetbrains.kotlin.gradle.tasks.FatFrameworkTask::class) {
            baseName = iosFrameworkName
            from(
                iosArm64().binaries.getFramework(iosFrameworkName, "Debug"),
                iosX64().binaries.getFramework(iosFrameworkName, "Debug")
            )
            destinationDir = buildDir.resolve("bin/universal/debug")
            group = "Universal framework"
            description = "Builds a universal (fat) debug framework"
            dependsOn("link${iosFrameworkName}DebugFrameworkIosArm64")
            dependsOn("link${iosFrameworkName}DebugFrameworkIosX64")
        }
        register("universalFrameworkRelease", org.jetbrains.kotlin.gradle.tasks.FatFrameworkTask::class) {
            baseName = iosFrameworkName
            from(
                iosArm64().binaries.getFramework(iosFrameworkName, "Release"),
                iosX64().binaries.getFramework(iosFrameworkName, "Release")
            )
            destinationDir = buildDir.resolve("bin/universal/release")
            group = "Universal framework"
            description = "Builds a universal (fat) release framework"
            dependsOn("link${iosFrameworkName}ReleaseFrameworkIosArm64")
            dependsOn("link${iosFrameworkName}ReleaseFrameworkIosX64")
        }
        register("universalFramework") {
            dependsOn("universalFrameworkDebug")
            dependsOn("universalFrameworkRelease")
        }
    }

    configure(listOf(targets["metadata"], android())) {
        mavenPublication {
            val targetPublication = this@mavenPublication
            tasks.withType<AbstractPublishToMaven>()
                .matching { it.publication == targetPublication }
        }
    }
}

android {
    namespace = "com.example.sharedlibrary"
    compileSdk = 34
    defaultConfig {
        minSdk = 23
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }
}
