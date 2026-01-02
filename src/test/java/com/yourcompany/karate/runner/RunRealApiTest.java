package com.yourcompany.karate.runner;

import com.intuit.karate.junit5.Karate;

class RunRealApiTest {

    @Karate.Test
    Karate real() {
        return Karate.run("classpath:features/real/postman-echo-date-formats-outline.feature");
    }
}
