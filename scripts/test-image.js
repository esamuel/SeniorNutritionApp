#!/usr/bin/env node

const https = require('https');
const fs = require('fs');
const path = require('path');

function downloadImage(url, filepath) {
  return new Promise((resolve, reject) => {
    const file = fs.createWriteStream(filepath);
    
    console.log(`📥 Downloading: ${url}`);
    console.log(`💾 Saving to: ${filepath}`);
    
    https.get(url, (response) => {
      // Handle redirects
      if (response.statusCode >= 300 && response.statusCode < 400 && response.headers.location) {
        file.close();
        fs.unlink(filepath, () => {});
        console.log(`↪️  Redirected to: ${response.headers.location}`);
        return downloadImage(response.headers.location, filepath).then(resolve).catch(reject);
      }
      
      if (response.statusCode === 200) {
        response.pipe(file);
        file.on('finish', () => {
          file.close();
          console.log('✅ Image downloaded successfully!');
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

async function testImageGeneration() {
  console.log('🧪 Testing image generation...');
  
  const imageDir = path.join(__dirname, '..', 'public', 'images', 'blog');
  const testImagePath = path.join(imageDir, 'test-senior-nutrition.jpg');
  
  // Ensure directory exists
  if (!fs.existsSync(imageDir)) {
    fs.mkdirSync(imageDir, { recursive: true });
  }
  
  try {
    // Test Lorem Picsum (most reliable)
    const testUrl = 'https://picsum.photos/800/400';
    await downloadImage(testUrl, testImagePath);
    
    const stats = fs.statSync(testImagePath);
    console.log(`📏 Image size: ${(stats.size / 1024).toFixed(1)} KB`);
    console.log(`🖼️  Image saved: public/images/blog/test-senior-nutrition.jpg`);
    
    // Clean up test file
    fs.unlinkSync(testImagePath);
    console.log('🧹 Test file cleaned up');
    
    return true;
  } catch (error) {
    console.error('❌ Image test failed:', error.message);
    return false;
  }
}

if (require.main === module) {
  testImageGeneration();
}