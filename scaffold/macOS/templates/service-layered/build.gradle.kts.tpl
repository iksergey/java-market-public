plugins {
    id("org.springframework.boot") version "__bootversion__" apply false
}

allprojects {
    group = "__basepkg__"
    version = "0.0.1-SNAPSHOT"

    repositories {
        mavenCentral()
    }
}

subprojects {
    apply(plugin = "java")

    extensions.configure<JavaPluginExtension> {
        toolchain {
            languageVersion.set(JavaLanguageVersion.of(__javaversion__))
        }
    }

    dependencies {
        "implementation"(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))
        "annotationProcessor"(platform("org.springframework.boot:spring-boot-dependencies:__bootversion__"))

        "compileOnly"("org.projectlombok:lombok")
        "annotationProcessor"("org.projectlombok:lombok")
    }
}
