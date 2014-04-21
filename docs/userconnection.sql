-- Table: userconnection

 DROP TABLE userconnection;

CREATE TABLE userconnection
(
  "rank" integer NOT NULL,
  "profileurl" character varying(255),
  "imageurl" character varying(255),
  "secret" character varying(255),
  "refreshtoken" character varying(255),
  "expiretime" bigint,
  "providerid" character varying(255) NOT NULL,
  "provideruserid" character varying(255),
  "accesstoken" character varying(255) NOT NULL,
  "displayname" character varying(255),
  "userid" character varying(255) NOT NULL,
  CONSTRAINT "userconnection_pk" PRIMARY KEY ("userid", "providerid", "rank")
)
WITH (
  OIDS=FALSE
);
ALTER TABLE userconnection
  OWNER TO eeg;
