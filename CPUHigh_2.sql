col metric_name for a25
col metric_unit for a25
select metric_name, value, metric_unit from v$sysmetric where metric_name like '%cpu%' and group_id=2;

select 'CPU_ORA_CONSUMED' CLASS,round(value/100,3) AAS from v$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2
union
select 'CPU_OS' CLASS, round((prcnt.busy*parameter.cpu_count)/100,3) sAAS from
(select value busy from v$sysmetric where metric_name='Host CPU Utilization (%)' and group_id=2) prcnt,
(select value cpu_count from v$parameter where name='cpu_count') parameter;

select 'CPU_ORA_CONSUMED' CLASS, round(value/100,3) AAS from v$sysmetric where metric_name='CPU Usage Per Sec' and group_id=2
union all
select 'CPU_OS' CLASS, round((prcnt.busy*parameter.cpu_count)/100,3) AAS from
(select value busy from v$sysmetric where metric_name='Host CPU Utilization (%)' and group_id=2) prcnt,
(select value cpu_count from v$parameter where name='cpu_count') parameter
union all
select 'CPU_ORA_DEMAND' CLASS, nvl(round( sum(decode(session_state,'ON CPU',1,0))/60,2),0) AAS
from v$active_session_history ash where SAMPLE_TIME > sysdate - (60/(24*60*60));

select
                 decode(n.wait_class,'User I/O','User I/O',
                                     'Commit','Commit',
                                     'Wait')                               CLASS,
                 sum(round(m.time_waited/m.INTSIZE_CSEC,3))                AAS
           from  v$waitclassmetric  m,
                 v$system_wait_class n
           where m.wait_class_id=n.wait_class_id
             and n.wait_class != 'Idle'
           group by  decode(n.wait_class,'User I/O','User I/O', 'Commit','Commit', 'Wait')
          union
             select 'CPU_ORA_CONSUMED'                                     CLASS,
                    round(value/100,3)                                     AAS
             from v$sysmetric
             where metric_name='CPU Usage Per Sec'
               and group_id=2
          union
            select 'CPU_OS'                                                CLASS ,
                    round((prcnt.busy*parameter.cpu_count)/100,3)          AAS
            from
              ( select value busy from v$sysmetric where metric_name='Host CPU Utilization (%)' and group_id=2 ) prcnt,
              ( select value cpu_count from v$parameter where name='cpu_count' )  parameter
          union
             select
               'CPU_ORA_DEMAND'                                            CLASS,
               nvl(round( sum(decode(session_state,'ON CPU',1,0))/60,2),0) AAS
             from v$active_session_history ash
             where SAMPLE_TIME > sysdate - (60/(24*60*60));