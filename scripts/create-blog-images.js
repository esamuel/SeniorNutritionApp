#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

// Create placeholder blog images by copying existing ones
function createPlaceholderImages() {
  const blogImagesDir = path.join(process.cwd(), 'public/images/blog');
  
  // Ensure the directory exists
  if (!fs.existsSync(blogImagesDir)) {
    fs.mkdirSync(blogImagesDir, { recursive: true });
  }
  
  // Generate image filenames based on blog titles (truncated to 50 chars)
  const blogTitles = [
    "10 Heart-Healthy Foods Every Senior Should Include in Their Diet",
    "The Complete Guide to Staying Hydrated as a Senior", 
    "Sleep Better at 60+: A Senior's Guide to Quality Rest",
    "Brain Health and Memory: Keeping Your Mind Sharp After 50",
    "Social Connection and Loneliness: Building Relationships in Your Golden Years"
  ];
  
  const neededImages = blogTitles.map(title => 
    title
      .toLowerCase()
      .replace(/[^\w\s-]/g, '')
      .replace(/\s+/g, '-')
      .substring(0, 50) + '.jpg'
  );
  
  // Check if we have a source image to copy from
  const existingImages = fs.readdirSync(blogImagesDir).filter(file => 
    file.endsWith('.jpg') || file.endsWith('.png')
  );
  
  if (existingImages.length === 0) {
    console.log('⚠️  No existing blog images found to use as templates');
    return;
  }
  
  const sourceImage = path.join(blogImagesDir, existingImages[0]);
  
  // Create missing images by copying an existing one
  neededImages.forEach(imageName => {
    const targetPath = path.join(blogImagesDir, imageName);
    
    if (!fs.existsSync(targetPath)) {
      try {
        fs.copyFileSync(sourceImage, targetPath);
        console.log('✅ Created placeholder image:', imageName);
      } catch (error) {
        console.error('❌ Failed to create image:', imageName, error.message);
      }
    } else {
      console.log('ℹ️  Image already exists:', imageName);
    }
  });
}

// Run if called directly
if (require.main === module) {
  createPlaceholderImages();
}

module.exports = { createPlaceholderImages };