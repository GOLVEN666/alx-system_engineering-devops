# 0x19. Postmortem

## Background Context

Any software system will eventually fail, and that failure can stem from a wide range of possible factors: bugs, traffic spikes, security issues, hardware failures, natural disasters, human error… Failing is normal and failing is actually a great opportunity to learn and improve. Any great Software Engineer must learn from their mistakes to make sure that they won’t happen again. Failing is fine, but failing twice because of the same issue is not.

A postmortem is a tool widely used in the tech industry. After any outage, the team(s) in charge of the system will write a summary that has 2 main goals:

1. To provide the rest of the company’s employees easy access to information detailing the cause of the outage. Often outages can have a huge impact on a company, so managers and executives have to understand what happened and how it will impact their work.
2. To ensure that the root cause(s) of the outage has been discovered and that measures are taken to make sure it will be fixed.

## Resources

Read or watch:
- [Incident Report, also referred to as a Postmortem](https://landing.google.com/sre/sre-book/chapters/postmortem-culture/)
- [The importance of an incident postmortem process](https://www.atlassian.com/incident-management/postmortem)
- [What is an Incident Postmortem?](https://sre.google/sre-book/postmortem-culture/)

## Tasks

### 0. My First Postmortem

Using one of the web stack debugging project issues or an outage you have personally faced, write a postmortem. Most of you will never have faced an outage, so just get creative and invent your own :)

#### Requirements:

**Issue Summary** (that is often what executives will read) must contain:
- Duration of the outage with start and end times (including timezone)
- What was the impact (what service was down/slow? What were users experiencing? How many % of the users were affected?)
- What was the root cause

**Timeline** (format bullet point, format: time - keep it short, 1 or 2 sentences) must contain:
- When was the issue detected
- How was the issue detected (monitoring alert, an engineer noticed something, a customer complained…)
- Actions taken (what parts of the system were investigated, what were the assumptions on the root cause of the issue)
- Misleading investigation/debugging paths that were taken
- Which team/individuals was the incident escalated to
- How the incident was resolved

**Root Cause and Resolution** must contain:
- Explain in detail what was causing the issue
- Explain in detail how the issue was fixed

**Corrective and Preventative Measures** must contain:
- What are the things that can be improved/fixed (broadly speaking)
- A list of tasks to address the issue (be very specific, like a TODO, example: patch Nginx server, add monitoring on server memory…)

Be brief and straight to the point, between 400 to 600 words.

---

### Postmortem: Database Connection Timeout Outage

#### Issue Summary

**Duration of the Outage:**
- Start Time: 2024-06-05 14:00 UTC
- End Time: 2024-06-05 15:30 UTC

**Impact:**
- The primary web application experienced a database connection timeout, leading to the unavailability of the main service. Users encountered "504 Gateway Timeout" errors.
- Approximately 85% of users were affected, disrupting both customer access to the site and internal employee usage.

**Root Cause:**
- The root cause was identified as an exhausted connection pool in the database due to an unoptimized query causing a spike in connection usage.

#### Timeline

- **14:00 UTC:** Issue detected via automated monitoring alert indicating database connection timeouts.
- **14:05 UTC:** On-call engineer confirmed the issue through error logs and user reports.
- **14:10 UTC:** Initial investigation started by checking recent deployments and changes to the application.
- **14:20 UTC:** Assumed the issue was due to a recent deployment; rollback initiated.
- **14:30 UTC:** Rollback completed but issue persisted.
- **14:35 UTC:** Further investigation into database logs revealed high connection usage.
- **14:40 UTC:** Identified an unoptimized query in the application code causing the spike.
- **14:45 UTC:** Escalated to the Database Administration (DBA) team for further analysis and resolution.
- **15:00 UTC:** DBA team optimized the query and increased the connection pool size as a temporary measure.
- **15:15 UTC:** Application performance restored; monitoring confirmed normal operation.
- **15:30 UTC:** Post-incident analysis began to determine long-term fixes.

#### Root Cause and Resolution

**Root Cause:**
- An unoptimized SQL query introduced in the latest application update caused excessive database connections. The connection pool was exhausted, leading to timeouts and the web application becoming unavailable.

**Resolution:**
- The problematic query was identified and optimized by adding appropriate indexes and rewriting the query to be more efficient.
- As a temporary measure, the connection pool size was increased to handle the immediate load:
  ```sql
  ALTER SYSTEM SET sessions = 500 SCOPE = BOTH;

