plugins {
    java
    id("org.springframework.boot")
}

dependencies {
    implementation(project(":__name__-infrastructure"))
    implementation(project(":__name__-application"))
    implementation(project(":__name__-domain"))

    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:3.1.1")
}

tasks.named<Jar>("jar") {
    enabled = false
}
