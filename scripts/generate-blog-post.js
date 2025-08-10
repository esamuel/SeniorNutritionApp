#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Blog post topics and content templates
const blogTopics = [
  {
    title: "10 Heart-Healthy Foods Every Senior Should Include in Their Diet",
    description: "Discover the top heart-healthy foods that can help seniors maintain cardiovascular health and reduce the risk of heart disease.",
    category: "Nutrition Tips & Guides",
    tags: ["heart health", "cardiovascular", "nutrition", "senior health", "healthy eating"],
    author: {
      name: "Dr. Sarah Johnson",
      bio: "Registered Dietitian specializing in senior nutrition"
    },
    content: `# 10 Heart-Healthy Foods Every Senior Should Include in Their Diet

As we age, maintaining heart health becomes increasingly important. Here are 10 heart-healthy foods that should be staples in every senior's diet.

## 1. Fatty Fish

Rich in omega-3 fatty acids, fish like salmon, mackerel, and sardines can help reduce inflammation and lower the risk of heart disease.

- Aim for 2-3 servings per week
- Choose wild-caught when possible
- Try grilling, baking, or steaming

## 2. Leafy Green Vegetables

Spinach, kale, and other leafy greens are packed with vitamins, minerals, and antioxidants.

- High in vitamin K
- Rich in nitrates
- Support healthy blood pressure

## 3. Whole Grains

Oats, quinoa, and brown rice provide fiber and nutrients that support heart health.

- Choose whole grain over refined
- Aim for 3-5 servings daily
- Look for 100% whole grain labels

## 4. Berries

Blueberries, strawberries, and raspberries are rich in antioxidants and fiber.

- Add to breakfast or snacks
- Fresh or frozen both work
- Natural source of vitamins

## 5. Avocados

Rich in monounsaturated fats and potassium, avocados support heart health.

- Use as a spread instead of butter
- Add to salads and sandwiches
- Rich in healthy fats

## 6. Nuts and Seeds

Almonds, walnuts, and flaxseeds provide healthy fats and protein.

- Choose unsalted varieties
- Portion control is important
- Great for snacking

## 7. Beans and Legumes

Black beans, lentils, and chickpeas are high in fiber and protein.

- Excellent plant-based protein
- Help lower cholesterol
- Versatile cooking options

## 8. Dark Chocolate

In moderation, dark chocolate (70% cacao or higher) can benefit heart health.

- Rich in antioxidants
- May help lower blood pressure
- Enjoy in small amounts

## 9. Tomatoes

High in lycopene, tomatoes support cardiovascular health.

- Better absorbed when cooked
- Add to sauces and soups
- Rich in vitamins C and K

## 10. Green Tea

Rich in antioxidants, green tea may help reduce the risk of heart disease.

- Drink 2-3 cups daily
- Choose organic when possible
- Can be enjoyed hot or cold

## Making It Work for You

Remember to consult with your healthcare provider before making significant dietary changes. Start by incorporating one or two of these foods into your weekly routine and gradually add more.

Your heart health is an investment in your future quality of life. These foods not only taste great but also provide the nutrients your heart needs to stay strong and healthy.`
  },
  {
    title: "The Complete Guide to Staying Hydrated as a Senior",
    description: "Learn why proper hydration is crucial for seniors and discover practical tips to maintain adequate fluid intake throughout the day.",
    category: "Health & Wellness",
    tags: ["hydration", "senior health", "wellness", "health tips", "healthy aging"],
    author: {
      name: "Dr. Michael Chen",
      bio: "Geriatrician and nutrition specialist with 15 years of experience in senior healthcare"
    },
    content: `# The Complete Guide to Staying Hydrated as a Senior

Proper hydration becomes increasingly important as we age. Here's everything seniors need to know about staying properly hydrated.

## Why Hydration Matters More for Seniors

As we age, our bodies undergo changes that make proper hydration more challenging:

- Decreased kidney function
- Reduced thirst sensation
- Lower total body water content
- Medication side effects

## Signs of Dehydration

Watch for these warning signs:

- Dark yellow urine
- Dry mouth and lips
- Fatigue or dizziness
- Confusion or irritability
- Constipation
- Headaches

## How Much Water Do Seniors Need?

Most seniors should aim for:

- 6-8 glasses of water daily
- More in hot weather or when exercising
- Consider your medications and health conditions
- Listen to your body's needs

## Best Hydration Strategies

### Start Your Day Right
- Drink a glass of water upon waking
- Keep water by your bedside
- Set morning hydration goals

### Make It Enjoyable
- Add lemon, cucumber, or mint to water
- Try herbal teas
- Include water-rich foods

### Create Reminders
- Set phone alarms
- Use a marked water bottle
- Link drinking to daily activities

## Hydrating Foods to Include

Many foods can contribute to your daily fluid intake:

- Watermelon (92% water)
- Cucumber (95% water)
- Tomatoes (94% water)
- Soup and broth
- Yogurt and milk

## When to Be Extra Careful

Increase fluid intake during:

- Hot weather
- Exercise or physical activity
- Illness, especially with fever
- Air travel
- High altitude locations

## Medications and Hydration

Some medications can affect hydration:

- Diuretics increase fluid loss
- Blood pressure medications
- Certain diabetes medications
- Always follow your doctor's advice

## Creating a Hydration Plan

1. **Morning**: Start with 16 oz of water
2. **With meals**: Have a glass with each meal
3. **Snack time**: Choose hydrating snacks
4. **Evening**: Sip water throughout the evening
5. **Before bed**: Small glass if needed

## Warning Signs to Contact Your Doctor

Seek medical attention if you experience:

- Severe dizziness or fainting
- Rapid heartbeat
- Confusion or disorientation
- Very dark urine or no urination
- Persistent nausea or vomiting

Remember, proper hydration is one of the simplest yet most important things you can do for your health. Stay consistent, listen to your body, and don't hesitate to ask your healthcare provider for personalized advice.`
  },
  {
    title: "Sleep Better at 60+: A Senior's Guide to Quality Rest",
    description: "Discover effective strategies and tips to improve sleep quality and overcome common sleep challenges faced by seniors.",
    category: "Healthy Aging",
    tags: ["sleep", "senior health", "healthy aging", "wellness", "sleep hygiene"],
    author: {
      name: "Dr. Elena Martinez",
      bio: "Sleep specialist focusing on age-related sleep disorders"
    },
    content: `# Sleep Better at 60+: A Senior's Guide to Quality Rest

Quality sleep is essential for healthy aging, yet many seniors struggle with sleep issues. Here's your comprehensive guide to better rest.

## Common Sleep Changes with Age

Normal aging brings several sleep changes:

- Earlier bedtime and wake time
- More fragmented sleep
- Less deep sleep
- Increased sensitivity to noise and light
- More frequent bathroom trips

## Creating the Perfect Sleep Environment

### Your Bedroom Setup
- Keep temperature between 65-68°F
- Use blackout curtains or eye mask
- Minimize noise with earplugs or white noise
- Invest in a comfortable mattress and pillows

### Technology Considerations
- Remove TVs and computers from bedroom
- Use blue light blocking glasses in evening
- Keep phones away from bed
- Consider a white noise machine

## Establishing a Sleep Routine

### Evening Wind-Down (2 hours before bed)
- Dim the lights
- Avoid large meals and caffeine
- Take a warm bath or shower
- Practice gentle stretching or yoga

### Consistent Schedule
- Go to bed at the same time nightly
- Wake up at the same time daily
- Maintain schedule on weekends
- Avoid long daytime naps

## Nutrition and Sleep

### Foods That Promote Sleep
- Tart cherries (natural melatonin)
- Warm milk with honey
- Almonds and walnuts
- Herbal teas (chamomile, passionflower)

### Foods to Avoid Before Bed
- Large meals within 3 hours of sleep
- Spicy or acidic foods
- Alcohol and caffeine
- Excessive fluids

## Physical Activity and Sleep

Regular exercise can improve sleep quality:

- Aim for 30 minutes of moderate activity daily
- Exercise at least 4 hours before bedtime
- Try gentle yoga or tai chi
- Take evening walks after dinner

## Managing Common Sleep Disruptors

### Frequent Urination
- Limit fluids 2 hours before bed
- Empty bladder before sleeping
- Use a bedside nightlight
- Consider a bedside commode if needed

### Chronic Pain
- Use supportive pillows for positioning
- Apply heat or cold therapy before bed
- Practice relaxation techniques
- Discuss pain management with your doctor

### Anxiety and Worry
- Keep a worry journal
- Practice deep breathing exercises
- Try progressive muscle relaxation
- Consider meditation apps

## When to See a Doctor

Consult your healthcare provider if you experience:

- Chronic insomnia (3+ weeks)
- Loud snoring or breathing interruptions
- Excessive daytime sleepiness
- Restless leg syndrome
- Sleep walking or other unusual behaviors

## Natural Sleep Aids

Consider these natural approaches:

- Melatonin (consult your doctor first)
- Valerian root tea
- Magnesium supplements
- Aromatherapy with lavender
- Meditation or mindfulness practices

## Creating Your Personal Sleep Plan

1. **Assessment**: Track your current sleep patterns
2. **Environment**: Optimize your bedroom
3. **Routine**: Establish consistent sleep/wake times
4. **Lifestyle**: Incorporate exercise and proper nutrition
5. **Relaxation**: Develop evening wind-down rituals
6. **Professional Help**: Consult doctors when needed

Remember, good sleep is not a luxury—it's essential for your physical health, mental well-being, and quality of life. Be patient as you implement changes, and don't hesitate to seek professional help when needed.

Sweet dreams and healthy aging!`
  },
  {
    title: "Brain Health and Memory: Keeping Your Mind Sharp After 50",
    description: "Learn evidence-based strategies to maintain cognitive health, improve memory, and reduce the risk of age-related mental decline.",
    category: "Mental Health & Wellness",
    tags: ["brain health", "memory", "cognitive function", "mental wellness", "healthy aging"],
    author: {
      name: "Dr. Robert Williams",
      bio: "Neurologist specializing in healthy brain aging"
    },
    content: `# Brain Health and Memory: Keeping Your Mind Sharp After 50

Maintaining cognitive health is crucial for successful aging. Here are proven strategies to keep your mind sharp and memory strong.

## Understanding Brain Changes with Age

Normal aging brings some cognitive changes:

- Slower processing speed
- Occasional memory lapses
- Need more time to learn new information
- Difficulty with multitasking
- Word-finding challenges

**Important**: Significant memory loss is NOT normal aging.

## The MIND Diet for Brain Health

The Mediterranean-DASH Intervention for Neurodegenerative Delay (MIND) diet includes:

### Brain-Boosting Foods
- Leafy green vegetables (6+ servings/week)
- Other vegetables (1+ serving/day)
- Berries (2+ servings/week)
- Nuts (5+ servings/week)
- Olive oil as primary cooking oil
- Whole grains (3+ servings/day)
- Fish (1+ serving/week)
- Beans and legumes (3+ servings/week)

### Foods to Limit
- Red meat (less than 4 servings/week)
- Butter and margarine (less than 1 tablespoon/day)
- Cheese (less than 1 serving/week)
- Fried foods (less than 1 serving/week)
- Sweets and pastries (less than 5 servings/week)

## Physical Exercise for the Brain

### Aerobic Exercise
- 150 minutes of moderate activity weekly
- Walking, swimming, cycling
- Improves blood flow to the brain
- Promotes new brain cell growth

### Strength Training
- 2-3 sessions per week
- Improves executive function
- Enhances memory performance
- Builds overall resilience

### Balance and Coordination
- Yoga or tai chi
- Dancing
- Improves brain connectivity
- Reduces fall risk

## Mental Stimulation Activities

### Challenge Your Brain Daily
- Learn a new language
- Play strategic games (chess, bridge)
- Do crossword puzzles or sudoku
- Take up a new hobby or skill

### Social Engagement
- Join clubs or groups
- Volunteer in your community
- Maintain friendships
- Engage in meaningful conversations

### Creative Activities
- Art, music, or writing
- Crafts and woodworking
- Cooking new recipes
- Gardening

## Sleep and Brain Health

Quality sleep is crucial for memory consolidation:

- Aim for 7-9 hours nightly
- Maintain consistent sleep schedule
- Create restful sleep environment
- Address sleep disorders promptly

## Stress Management for Cognitive Health

Chronic stress can harm the brain:

### Stress Reduction Techniques
- Meditation and mindfulness
- Deep breathing exercises
- Progressive muscle relaxation
- Regular prayer or spiritual practices

### Social Support
- Maintain close relationships
- Join support groups
- Stay connected with family
- Seek professional help when needed

## Memory Strategies and Techniques

### Organization Methods
- Use calendars and planners
- Create to-do lists
- Establish routines
- Keep important items in designated places

### Memory Enhancement Techniques
- Repeat information aloud
- Create mental associations
- Use visual imagery
- Break information into chunks
- Practice active recall

## Technology Tools for Brain Health

### Helpful Apps and Devices
- Brain training games (in moderation)
- Meditation apps
- Calendar and reminder apps
- GPS navigation when needed

### Stay Connected
- Video calls with family
- Social media for positive connections
- Online learning platforms
- Virtual hobby groups

## Warning Signs to Watch For

Contact your doctor if you notice:

- Getting lost in familiar places
- Difficulty managing finances
- Trouble following conversations
- Personality changes
- Problems with daily activities
- Confusion about time or place

## Creating Your Brain Health Plan

1. **Nutrition**: Adopt MIND diet principles
2. **Exercise**: Include aerobic and strength training
3. **Mental Challenge**: Engage in learning activities
4. **Social Connection**: Maintain relationships
5. **Sleep**: Prioritize quality rest
6. **Stress Management**: Practice relaxation techniques
7. **Medical Care**: Regular check-ups and screenings

## The Bottom Line

Brain health is largely within your control. The lifestyle choices you make today can significantly impact your cognitive health in the years to come. Start with small changes and build healthy habits gradually.

Remember: It's never too late to start taking care of your brain. Every positive step you take can make a difference in maintaining your mental sharpness and independence as you age.

Stay curious, stay active, and stay connected—your brain will thank you!`
  },
  {
    title: "Social Connection and Loneliness: Building Relationships in Your Golden Years",
    description: "Discover the importance of social connections for senior health and practical ways to build meaningful relationships and combat loneliness.",
    category: "Mental Health & Wellness",
    tags: ["social connection", "loneliness", "mental health", "senior wellness", "community"],
    author: {
      name: "Dr. Sarah Johnson",
      bio: "Geriatric psychologist specializing in senior mental health"
    },
    content: `# Social Connection and Loneliness: Building Relationships in Your Golden Years

Social connections are vital for healthy aging. Learn how to build meaningful relationships and combat loneliness in your senior years.

## The Health Impact of Social Connection

Research shows that strong social connections can:

- Reduce risk of depression and anxiety
- Lower blood pressure and heart disease risk
- Boost immune system function
- Improve cognitive function
- Increase longevity by up to 50%
- Enhance overall quality of life

## Understanding Loneliness vs. Being Alone

### Loneliness
- Feeling of isolation despite being around others
- Lack of meaningful connections
- Emotional distress from social disconnection
- Can occur even in crowded places

### Being Alone
- Physical state of solitude
- Can be chosen and enjoyed
- Doesn't necessarily involve emotional distress
- Can be restorative and peaceful

## Common Causes of Senior Isolation

### Life Transitions
- Retirement from work
- Loss of spouse or friends
- Children moving away
- Health limitations
- Transportation challenges

### Physical Barriers
- Mobility issues
- Hearing or vision problems
- Chronic health conditions
- Living in remote areas
- Lack of accessible transportation

## Building New Social Connections

### Community Involvement
- Join senior centers
- Participate in religious organizations
- Volunteer for causes you care about
- Attend community events and festivals
- Join hobby or interest groups

### Learning Opportunities
- Take classes at community colleges
- Join book clubs
- Attend lectures and workshops
- Participate in discussion groups
- Learn new skills with others

### Physical Activities
- Join walking groups
- Participate in senior fitness classes
- Try group activities like bowling or golf
- Join swimming or water aerobics classes
- Practice tai chi or yoga in groups

## Maintaining Existing Relationships

### Family Connections
- Schedule regular phone calls or video chats
- Plan family gatherings and reunions
- Share family photos and memories
- Attend grandchildren's events
- Create family traditions

### Friendships
- Make effort to stay in regular contact
- Plan activities together
- Be a good listener
- Offer support during difficult times
- Celebrate milestones and achievements

## Technology for Social Connection

### Getting Started with Technology
- Ask family members to teach you
- Take computer classes for seniors
- Start with simple video calling apps
- Use tablets which are often easier than computers
- Don't be afraid to make mistakes

### Useful Platforms
- Video calling: FaceTime, Zoom, Skype
- Social media: Facebook for family updates
- Messaging: WhatsApp, text messaging
- Email for longer communications
- Online gaming with friends or family

## Creating Social Opportunities

### Hosting at Home
- Organize small dinner parties
- Host game nights or movie nights
- Start a regular coffee group
- Create seasonal celebrations
- Invite neighbors for casual visits

### Joining Groups
- Find groups that match your interests
- Start small with one or two activities
- Be patient as relationships develop
- Be open to trying new things
- Consider both social and service-oriented groups

## Overcoming Social Anxiety

### Start Small
- Begin with low-pressure activities
- Bring a friend to new events
- Arrive early when crowds are smaller
- Set realistic goals for interaction
- Practice conversation starters

### Building Confidence
- Focus on being a good listener
- Ask questions about others' interests
- Share your own experiences appropriately
- Remember that others may be shy too
- Celebrate small social successes

## The Role of Pets in Social Connection

### Benefits of Pet Companionship
- Provide unconditional love and comfort
- Create opportunities to meet other pet owners
- Encourage regular outdoor activity
- Reduce stress and anxiety
- Provide purpose and routine

### Pet Considerations for Seniors
- Choose pets appropriate for your lifestyle
- Consider lower-maintenance options
- Plan for pet care if you become ill
- Look into pet therapy programs
- Consider fostering if long-term commitment is difficult

## Professional Support

### When to Seek Help
- Persistent feelings of loneliness
- Signs of depression or anxiety
- Difficulty leaving home
- Loss of interest in activities
- Thoughts of self-harm

### Types of Support Available
- Counseling and therapy
- Support groups
- Community mental health services
- Senior companion programs
- Transportation assistance programs

## Creating Your Social Connection Plan

1. **Assess Current Relationships**: List your current social connections
2. **Identify Interests**: What activities do you enjoy or want to try?
3. **Set Goals**: Start with one new social activity per week
4. **Take Action**: Sign up for activities or reach out to friends
5. **Be Patient**: Relationships take time to develop
6. **Stay Consistent**: Regular participation builds connections
7. **Evaluate and Adjust**: What's working? What needs to change?

## Red Flags: When Loneliness Becomes Concerning

Seek professional help if you experience:

- Persistent sadness or hopelessness
- Loss of appetite or sleep problems
- Withdrawal from all activities
- Thoughts of death or suicide
- Increased alcohol or medication use
- Neglecting personal care

## The Ripple Effect of Connection

Remember that building social connections doesn't just benefit you—it helps others too. Your friendship, wisdom, and companionship are valuable gifts you can offer to others in your community.

Social connection is not a luxury—it's a necessity for healthy aging. Take the first step today, whether it's making a phone call, joining a group, or simply saying hello to a neighbor. Your future self will thank you for the investment in relationships you make today.

Start small, be patient with yourself, and remember that it's never too late to make new friends or strengthen existing relationships. Your golden years can truly be golden when filled with meaningful connections and supportive relationships.`
  }
];

// Get the next topic to write about
function getNextTopic() {
  const postsDir = path.join(process.cwd(), 'src/app/blog/posts');
  const existingPosts = fs.readdirSync(postsDir);
  
  // Find which topics haven't been used yet
  const usedTitles = existingPosts.map(filename => {
    const content = fs.readFileSync(path.join(postsDir, filename), 'utf8');
    const match = content.match(/title: ["']([^"']+)["']/);
    return match ? match[1] : null;
  }).filter(Boolean);
  
  // Return the first unused topic
  for (const topic of blogTopics) {
    if (!usedTitles.includes(topic.title)) {
      return topic;
    }
  }
  
  // If all topics are used, cycle back to the beginning
  return blogTopics[0];
}

// Generate filename from title
function generateFilename(title) {
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .substring(0, 50) + '.mdx';
}

// Generate image filename from title (used for image paths)
function generateImageFilename(title) {
  return title
    .toLowerCase()
    .replace(/[^\w\s-]/g, '')
    .replace(/\s+/g, '-')
    .substring(0, 50) + '.jpg';
}

// Generate current date in YYYY-MM-DD format
function getCurrentDate() {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
}

// Generate blog post content
function generateBlogPost(topic) {
  const frontMatter = `---
title: "${topic.title}"
description: "${topic.description}"
date: "${getCurrentDate()}"
author:
  name: "${topic.author.name}"
  bio: "${topic.author.bio}"
category: "${topic.category}"
tags: [${topic.tags.map(tag => `"${tag}"`).join(', ')}]
image: "/images/blog/${generateImageFilename(topic.title)}"
readingTime: "8 min read"
---

${topic.content}`;

  return frontMatter;
}

// Main function
function main() {
  try {
    console.log('🚀 Generating new blog post...');
    
    const nextTopic = getNextTopic();
    const filename = generateFilename(nextTopic.title);
    const content = generateBlogPost(nextTopic);
    
    const postsDir = path.join(process.cwd(), 'src/app/blog/posts');
    const filepath = path.join(postsDir, filename);
    
    // Check if file already exists
    if (fs.existsSync(filepath)) {
      console.log('⚠️  Post already exists:', filename);
      return;
    }
    
    // Write the new blog post
    fs.writeFileSync(filepath, content, 'utf8');
    
    console.log('✅ Successfully created new blog post:');
    console.log('📄 File:', filename);
    console.log('📝 Title:', nextTopic.title);
    console.log('📅 Date:', getCurrentDate());
    console.log('👤 Author:', nextTopic.author.name);
    
  } catch (error) {
    console.error('❌ Error generating blog post:', error.message);
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { generateBlogPost, getNextTopic };