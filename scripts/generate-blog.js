#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const https = require('https');
const { execSync } = require('child_process');

// Senior nutrition topics pool
const NUTRITION_TOPICS = [
  'Heart-healthy foods and recipes for seniors',
  'Managing diabetes through proper nutrition',
  'Calcium and vitamin D for bone health in aging',
  'Hydration tips and importance for older adults',
  'Anti-inflammatory foods to reduce joint pain',
  'Brain-boosting nutrients for cognitive health',
  'Fiber-rich foods for digestive health',
  'Protein needs and sources for seniors',
  'Managing high blood pressure with diet',
  'Weight management strategies for seniors',
  'Meal prep and planning for independent living',
  'Supplements: what seniors really need',
  'Foods to boost immune system in older adults',
  'Managing cholesterol through nutrition',
  'Easy-to-chew foods for dental challenges',
  'Preventing osteoporosis with nutrition',
  'Energy-boosting foods for active seniors',
  'Managing acid reflux through diet',
  'Iron deficiency prevention in seniors',
  'Social eating and combating loneliness'
];

const AUTHORS = [
  { name: "Dr. Sarah Johnson", bio: "Registered Dietitian specializing in senior nutrition" },
  { name: "Dr. Michael Chen", bio: "Geriatrician and nutrition specialist" },
  { name: "Lisa Rodriguez, RD", bio: "Senior nutrition consultant and meal planning expert" },
  { name: "Dr. Patricia Williams", bio: "Geriatric medicine and preventive nutrition specialist" }
];

async function callOllama(prompt) {
  try {
    const response = await fetch('http://localhost:11434/api/generate', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: 'llama3.1:8b',
        prompt: prompt,
        stream: false
      })
    });
    
    const data = await response.json();
    return data.response;
  } catch (error) {
    console.error('Error calling Ollama:', error);
    throw error;
  }
}

function generateSlug(title) {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9\s-]/g, '')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .substring(0, 60);
}

function getRandomAuthor() {
  return AUTHORS[Math.floor(Math.random() * AUTHORS.length)];
}

function getRandomTopic() {
  return NUTRITION_TOPICS[Math.floor(Math.random() * NUTRITION_TOPICS.length)];
}

// Free image generation with multiple fallback options
async function generateImage(topic, slug) {
  const imageDir = path.join(__dirname, '..', 'public', 'images', 'blog');
  const imagePath = path.join(imageDir, `${slug}.jpg`);
  
  // Ensure directory exists
  if (!fs.existsSync(imageDir)) {
    fs.mkdirSync(imageDir, { recursive: true });
  }
  
  // If image already exists, return existing path
  if (fs.existsSync(imagePath)) {
    console.log(`📸 Using existing image: ${slug}.jpg`);
    return `/images/blog/${slug}.jpg`;
  }
  
  try {
    // Generate search keywords for the image
    const keywords = await generateImageKeywords(topic);
    console.log(`🔍 Searching for image with keywords: ${keywords}`);
    
    // Try multiple free image services
    const imageServices = [
      `https://picsum.photos/800/400`, // Lorem Picsum (always works)
      `https://source.unsplash.com/800x400/?${encodeURIComponent(keywords)}`, // Unsplash
      `https://loremflickr.com/800/400/${encodeURIComponent(keywords)}` // LoremFlickr
    ];
    
    for (let i = 0; i < imageServices.length; i++) {
      try {
        console.log(`📥 Trying image service ${i + 1}...`);
        await downloadImage(imageServices[i], imagePath);
        console.log(`📸 Generated image: ${slug}.jpg`);
        return `/images/blog/${slug}.jpg`;
      } catch (serviceError) {
        console.log(`⚠️  Service ${i + 1} failed: ${serviceError.message}`);
        if (i === imageServices.length - 1) {
          throw serviceError;
        }
      }
    }
  } catch (error) {
    console.log(`⚠️  All image services failed: ${error.message}`);
    console.log(`📸 Using fallback image`);
    return '/images/screenshots/nutrition-tracking.png';
  }
}

async function generateImageKeywords(topic) {
  const keywordPrompt = `Generate 2-3 search keywords for finding a relevant stock photo for an article about "${topic}". 
Keywords should be:
- Simple, common terms
- Related to healthy food, nutrition, or seniors
- Separated by commas
- Examples: "healthy food", "senior nutrition", "fresh vegetables"

Just return the keywords, nothing else.`;
  
  try {
    const keywords = await callOllama(keywordPrompt);
    return keywords.trim().replace(/["']/g, '').replace(/\s*,\s*/g, ',');
  } catch (error) {
    // Fallback keywords based on topic
    if (topic.includes('heart')) return 'heart,healthy,food';
    if (topic.includes('diabetes')) return 'diabetes,nutrition,healthy';
    if (topic.includes('bone')) return 'calcium,milk,strong';
    if (topic.includes('brain')) return 'brain,food,nutrition';
    return 'senior,nutrition,healthy';
  }
}

function downloadImage(url, filepath) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filepath);
    
    https.get(url, (response) => {
      // Handle redirects
      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        file.close();
        fs.unlink(filepath, () => {});
        return downloadImage(response.headers.location, filepath).then(resolve).catch(reject);
      }
      
      if (response.statusCode === 200) {
        response.pipe(file);
        file.on('finish', () => {
          file.close();
          resolve();
        });
      } else {
        file.close();
        fs.unlink(filepath, () => {});
        reject(new Error(`HTTP ${response.statusCode}: ${response.statusMessage}`));
      }
    }).on('error', (error) => {
      file.close();
      fs.unlink(filepath, () => {}); // Delete partial file
      reject(error);
    });
  });
}

async function generateBlogPost() {
  const topic = getRandomTopic();
  const author = getRandomAuthor();
  const currentDate = new Date().toISOString().split('T')[0];
  
  console.log(`🤖 Generating blog post about: ${topic}`);
  
  // Generate image for the blog post
  const imagePath = await generateImage(topic, generateSlug(topic));
  
  const prompt = `Write a comprehensive, expert-level blog post about "${topic}" specifically for seniors aged 65+. 

Structure the post as follows:
1. Start with an engaging introduction explaining why this topic matters for seniors
2. Include 4-6 main sections with clear headings (use ## for headings)
3. Provide practical, actionable advice throughout
4. Include specific food recommendations, portions, and safety considerations
5. Add tips for implementation and real-world application
6. End with a reminder to consult healthcare providers and mention how the Senior Nutrition App can help

Writing guidelines:
- Write in a warm, encouraging, but professional tone
- Use simple, clear language (8th grade reading level)
- Include specific examples and practical tips
- Mention safety considerations for seniors (medications, health conditions)
- Keep paragraphs short and easy to read
- Use bullet points and numbered lists for clarity
- Aim for 800-1200 words
- Do not include a title at the beginning - I'll add that separately

Focus on evidence-based nutrition advice that's specifically relevant to the unique needs of older adults.`;

  try {
    const content = await callOllama(prompt);
    
    // Generate title using AI
    const titlePrompt = `Create a compelling, SEO-friendly blog post title for an article about "${topic}" for seniors. The title should be:
- Clear and specific
- Include "seniors" or "older adults"
- 50-60 characters long
- Engaging but professional
- No quotes around the title

Just return the title, nothing else.`;
    
    const title = (await callOllama(titlePrompt)).trim().replace(/"/g, '');
    
    // Generate description
    const descPrompt = `Write a compelling 120-160 character meta description for a blog post titled "${title}" about senior nutrition. Make it engaging and include a call to action. Just return the description, nothing else.`;
    
    const description = (await callOllama(descPrompt)).trim().replace(/"/g, '');
    
    const slug = generateSlug(title);
    
    // Create frontmatter and full content
    const frontmatter = `---
title: "${title}"
description: "${description}"
date: "${currentDate}"
author:
  name: "${author.name}"
  bio: "${author.bio}"
category: "Nutrition Tips & Guides"
tags: ["nutrition", "senior health", "healthy eating", "wellness"]
image: "${imagePath}"
---

# ${title}

${content}`;

    // Save to file
    const postsDir = path.join(__dirname, '..', 'src', 'app', 'blog', 'posts');
    const filename = `${slug}.mdx`;
    const filepath = path.join(postsDir, filename);
    
    // Check if file already exists
    if (fs.existsSync(filepath)) {
      console.log(`⚠️  File already exists: ${filename}`);
      return null;
    }
    
    fs.writeFileSync(filepath, frontmatter);
    console.log(`✅ Generated blog post: ${filename}`);
    console.log(`📝 Title: ${title}`);
    
    return {
      filename,
      title,
      slug
    };
  } catch (error) {
    console.error('❌ Error generating blog post:', error);
    throw error;
  }
}

async function commitToGit(filename, title) {
  try {
    execSync(`git add src/app/blog/posts/${filename} public/images/blog/`, { cwd: __dirname + '/..' });
    execSync(`git commit -m "feat: Add new blog post - ${title}

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>"`, { cwd: __dirname + '/..' });
    
    console.log('✅ Changes committed to git');
  } catch (error) {
    console.log('⚠️  Git commit failed (this is okay if not in a git repo):', error.message);
  }
}

async function main() {
  console.log('🚀 Starting automated blog generation...');
  
  try {
    // Check if Ollama is running
    const response = await fetch('http://localhost:11434/api/tags');
    if (!response.ok) {
      throw new Error('Ollama server not responding');
    }
    
    const result = await generateBlogPost();
    
    if (result) {
      // Commit to git
      await commitToGit(result.filename, result.title);
      
      console.log('\n🎉 Blog generation complete!');
      console.log(`📁 File: src/app/blog/posts/${result.filename}`);
      console.log(`🌐 Will be available at: /blog/${result.slug}`);
    } else {
      console.log('⏭️  Skipped generation (file already exists)');
    }
    
  } catch (error) {
    console.error('❌ Blog generation failed:', error.message);
    
    if (error.message.includes('Ollama')) {
      console.log('\n💡 Make sure Ollama is running:');
      console.log('   ollama serve');
    }
    
    process.exit(1);
  }
}

// Run if called directly
if (require.main === module) {
  main();
}

module.exports = { generateBlogPost, callOllama };