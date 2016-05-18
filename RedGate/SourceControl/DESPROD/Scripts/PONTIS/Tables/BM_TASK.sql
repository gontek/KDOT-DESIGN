CREATE TABLE pontis.bm_task (
  task_id NUMBER(3) NOT NULL,
  task_shrt_dscrptn VARCHAR2(25 BYTE),
  task_dscrptn VARCHAR2(250 BYTE),
  end_date DATE,
  CONSTRAINT pk_task_id PRIMARY KEY (task_id)
);