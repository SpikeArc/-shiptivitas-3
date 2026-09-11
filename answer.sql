-- ====================================================================
-- PART 1: SQL QUERIES FOR DATA VISUALIZATION
-- ====================================================================

-- 1. Daily Active Users (DAU) before and after the feature change
-- This extracts unique daily logins to plot the DAU line graph.
SELECT 
    DATE(activity_timestamp) AS activity_date, 
    COUNT(DISTINCT user_id) AS daily_active_users,
    CASE 
        WHEN DATE(activity_timestamp) < '2026-09-01' THEN 'Before Release'
        ELSE 'After Release' 
    END AS release_window
FROM 
    user_sessions
GROUP BY 
    DATE(activity_timestamp), 
    release_window
ORDER BY 
    activity_date ASC;


-- 2. Number of status changes by card (daily)
-- This extracts the movement frequency to plot feature engagement.
SELECT 
    DATE(change_timestamp) AS change_date,
    card_id,
    COUNT(*) AS total_status_changes
FROM 
    card_audit_logs
WHERE 
    old_status != new_status
GROUP BY 
    DATE(change_timestamp), 
    card_id
ORDER BY 
    change_date ASC, 
    total_status_changes DESC;


/*
====================================================================
PART 2: ACTIONABLE IDEAS TO INCREASE DAILY ACTIVE USERS (DAU)
====================================================================

IDEA 1: "Stale Task" Bottleneck Alerts
- Hypothesis: If we visually highlight cards that have not changed swimlanes in over 48 hours, freight managers will log in daily specifically to unblock delayed shipments.
- Expected Impact: Medium-High. Anticipated 10% increase in DAU and a reduction in average task completion time. 
- What the feature is: A visual modifier on the frontend (e.g., a red border or "stale" badge on the Card component) that triggers automatically based on a timestamp diff. Accompanied by a daily morning email digest summarizing blocked cards.

IDEA 2: Automated Status-Change Notifications
- Hypothesis: If users receive automated ping notifications when a card they are watching moves to "In-Progress" or "Complete," they will return to the application multiple times a day to view updates.
- Expected Impact: High. Anticipated 15-20% increase in DAU due to the creation of an external trigger loop.
- What the feature is: An event-driven notification system. Users can "Subscribe" to a specific client card. When another team member drags that card to a new swimlane, the subscribed user gets an in-app and email notification.

IDEA 3: In-Card @Mention Comments
- Hypothesis: If freight managers can tag their team members directly on a card to ask for status updates, it will shift communication from external tools (Slack/Email) into our platform, driving daily logins.
- Expected Impact: High. Anticipated 25% increase in DAU by building internal team network effects.
- What the feature is: A simple comment thread added to the expanded view of a Card. Typing '@' queries the user table, and submitting the comment sends an alert to the tagged colleague with a direct link to open the board.
*/
