name := "interview"

version := "1.0"

organization := "interview-banking"

scalaVersion := "2.10.2"

libraryDependencies ++= Seq(
  "org.scalatest" %% "scalatest" % "2.2.1" % "test",
  "info.cukes" %% "cucumber-scala" % "1.2.4" % "test",
  "info.cukes" % "cucumber-junit" % "1.2.4" % "test"
)

Seq(cucumberSettingsWithTestPhaseIntegration: _*)