lazy val root = project in file(".") dependsOn `sbt-haxe`

lazy val `sbt-haxe` = RootProject(uri("https://github.com/ThoughtWorksInc/sbt-haxe#haxe-macro"))