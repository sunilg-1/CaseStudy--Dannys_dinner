# CaseStudy--Dannys_dinner

<img src="https://user-images.githubusercontent.com/95043221/191195617-b433b2c7-8257-4377-880c-f4b5517cc90d.png" width="450">


Danny's_dinner #1 is the first case study project you can do to practice your Mysql skill's in your free time you can find it here [8weeksqlchallenge.com/case-study-1](https://8weeksqlchallenge.com/case-study-1/).

## Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

## Problem-Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:

* sales
* menu
* members
You can inspect the entity relationship diagram and example data below.

![image](https://user-images.githubusercontent.com/95043221/191195378-42db0fd5-79d7-40a8-aa66-c4563d9e98d8.png)

## CaseStudy Questions with Answers

1. What is the total amount each customer spent at the restaurant?
 * By using simple `SUM()` and `JOIN()` we can see how much each customer spent in($)
   * Customer A spent 76
   * Customer B spent 74
   * Customer C spent 36.
2. How many days has each customer visited the restaurant?
 * By using `COUNT(DISTINCT)` we get the results
   * Customer A visited 4
   * Customer B visited 6
   * Customer C visited 2.
3. What was the first item from the menu purchased by each customer?
 * using `MIN()` with `GROUP BY`will return minimum value from the table which is first purchase.
   * Customer A purchased Sushi.
   * Customer A purchased Curry.
   * Customer A purchased Ramen.
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
 * Most purchased item from menu was Ramen 8 times.
5. Which item was the most popular for each customer?
 * Here i used Window Function `DENSE_RANK()` in a subquery to get repeted orders for each customer and got popular orders shown below,
   * A	ramen
   * B	curry
   * B	sushi
   * B	ramen
   * C	ramen.
6. Which item was purchased first by the customer after they became a member?
   * Customer A	joined on 2021-01-07 and his first order was on the same day he ordered curry.
   * Customer B	joined on 2021-01-09 his first order was sushi on	2021-01-11.
7. Which item was purchased just before the customer became a member?
 * with same `DENSE_RANK()` function these are the items customers purchased before becoming a member
   * A	sushi
   * A	curry
   * B	curry
8. What is the total items and amount spent for each member before they became a member?
   * Customer B	has bought 3 items worth	40$ before becoming member.
   * Customer A	has bought 2 items worth 25$ before becoming member.
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
  * Customer A	will have 860 points.
  * Customer B	will have 940 points.
  * Customer C	will have 360 points.
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
 * As the question says the customers earn 2x points(1$ spent = 10 points) in the first week after becoming the member for all items except 'sushi', after that week they earn 1x for rest of month, And asked me to calculate the total points at end of January by both the customers.
  * so the customer B	has 520 points at the end.
  * and Customer A earns 1270 points at the end.
  
## You can find all the Mysql queries leading to these results Here:
[dannys_dinner](Dannys_dinner_query_file.sql)

