plugins {
    `java-library`
}

dependencies {
    implementation(project(":__name__-domain"))

    api("__basepkg__:common-kernel:0.0.1-SNAPSHOT")

    implementation("org.mapstruct:mapstruct:1.6.3")
    annotationProcessor("org.mapstruct:mapstruct-processor:1.6.3")
    annotationProcessor("org.projectlombok:lombok-mapstruct-binding:0.2.0")
}
