To start
-- -----
java -javaagent:contrast-eop/contrast.jar -Dcontrast.dir=contrast-eop/ -jar ./target/spring-petclinic-1.5.1.jar

NOTE: The mvn wrapper doesn't work with Contrast.

SQL injection exploit
--- --------- -------

Find Owners: D' OR '1%'='1

