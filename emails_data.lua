-- email content database
-- action: "keep" or "delete"
-- difficulty: 1=easy, 2=medium, 3=hard

email_templates = {
  -- EASY SPAM (clearly junk)
  {
    subject="you won $1000000!!!",
    body="click here now!!!",
    avatar=64,
    difficulty=1,
    action="delete"
  },
  {
    subject="hot singles near you",
    body="meet them tonight!",
    avatar=65,
    difficulty=1,
    action="delete"
  },
  {
    subject="viagra cheap now!!!",
    body="best prices online",
    avatar=66,
    difficulty=1,
    action="delete"
  },
  {
    subject="nigerian prince here",
    body="i need your help $$$",
    avatar=67,
    difficulty=1,
    action="delete"
  },
  
  -- EASY RELEVANT (clearly important)
  {
    subject="quarterly review mtg",
    body="tomorrow at 2pm conf rm",
    avatar=80,
    difficulty=1,
    action="keep"
  },
  {
    subject="project deadline fri",
    body="please submit reports",
    avatar=81,
    difficulty=1,
    action="keep"
  },
  {
    subject="payroll update",
    body="direct deposit changed",
    avatar=82,
    difficulty=1,
    action="keep"
  },
  {
    subject="client call today",
    body="3pm with acme corp",
    avatar=83,
    difficulty=1,
    action="keep"
  },
  
  -- MEDIUM SPAM (looks somewhat legit)
  {
    subject="confirm your account",
    body="click to verify email",
    avatar=68,
    difficulty=2,
    action="delete"
  },
  {
    subject="your package delayed",
    body="update shipping info",
    avatar=69,
    difficulty=2,
    action="delete"
  },
  {
    subject="security alert!",
    body="verify your login now",
    avatar=70,
    difficulty=2,
    action="delete"
  },
  {
    subject="special offer 4 u",
    body="limited time discount",
    avatar=71,
    difficulty=2,
    action="delete"
  },
  {
    subject="weekly newsletter",
    body="10 tips you must know",
    avatar=72,
    difficulty=2,
    action="delete"
  },
  
  -- MEDIUM RELEVANT (somewhat important)
  {
    subject="team lunch thursday",
    body="italian place at noon",
    avatar=84,
    difficulty=2,
    action="keep"
  },
  {
    subject="budget approval needed",
    body="review attached docs",
    avatar=85,
    difficulty=2,
    action="keep"
  },
  {
    subject="server maintenance",
    body="downtime saturday 2am",
    avatar=86,
    difficulty=2,
    action="keep"
  },
  
  -- HARD SPAM (very convincing)
  {
    subject="re: your last invoice",
    body="please review charges",
    avatar=73,
    difficulty=3,
    action="delete"
  },
  {
    subject="it dept: action needed",
    body="update your password",
    avatar=74,
    difficulty=3,
    action="delete"
  },
  {
    subject="expense report issue",
    body="resubmit form asap",
    avatar=75,
    difficulty=3,
    action="delete"
  },
  
  -- HARD RELEVANT (easy to miss)
  {
    subject="optional training",
    body="career development opp",
    avatar=87,
    difficulty=3,
    action="keep"
  },
  {
    subject="fyi: policy change",
    body="new remote work rules",
    avatar=88,
    difficulty=3,
    action="keep"
  },
  {
    subject="team survey",
    body="your feedback wanted",
    avatar=80,
    difficulty=3,
    action="keep"
  },
}
