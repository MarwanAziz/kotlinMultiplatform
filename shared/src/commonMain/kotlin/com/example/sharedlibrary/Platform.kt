package com.example.sharedlibrary

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform