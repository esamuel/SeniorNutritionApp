import { Metadata } from 'next'
import { getAllPosts } from './utils/loadPosts'
import BlogPostCard from './components/BlogPostCard'
import Navbar from "../components/Navbar";

export const metadata: Metadata = {
  title: 'Senior Nutrition Blog - Health & Wellness Tips for Seniors',
  description: 'Expert advice on senior nutrition, healthy aging, recipes, and wellness tips to help seniors maintain a healthy lifestyle.',
}

export default function BlogPage() {
  const posts = getAllPosts()

  return (
    <>
      <Navbar />
      <main className="min-h-screen pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <div className="max-w-7xl mx-auto">
          <div className="text-center mb-12">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              Senior Nutrition Blog
            </h1>
            <p className="text-xl text-gray-600">
              Expert advice on nutrition, health, and wellness for seniors
            </p>
          </div>
          
          {/* Featured Posts Section */}
          <section className="mb-16">
            <h2 className="text-2xl font-semibold text-gray-900 mb-6">
              Featured Articles
            </h2>
            <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
              {posts.slice(0, 3).map(post => (
                <BlogPostCard key={post.slug} post={post} />
              ))}
            </div>
          </section>

          {/* All Posts Section */}
          <section className="mb-16">
            <h2 className="text-2xl font-semibold text-gray-900 mb-6">
              All Articles
            </h2>
            <div className="grid gap-8 md:grid-cols-2 lg:grid-cols-3">
              {posts.map(post => (
                <BlogPostCard key={post.slug} post={post} />
              ))}
            </div>
          </section>

          {/* Newsletter Section */}
          <section className="bg-blue-50 rounded-xl p-8 mb-16">
            <div className="max-w-2xl mx-auto text-center">
              <h2 className="text-2xl font-semibold text-gray-900 mb-4">
                Stay Updated
              </h2>
              <p className="text-gray-600 mb-6">
                Subscribe to our newsletter for the latest articles on senior nutrition and healthy living.
              </p>
              <div className="flex gap-4 max-w-md mx-auto">
                <input
                  type="email"
                  placeholder="Enter your email"
                  className="flex-1 px-4 py-2 rounded-md border border-gray-300 focus:outline-none focus:ring-2 focus:ring-blue-500"
                />
                <button className="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors">
                  Subscribe
                </button>
              </div>
            </div>
          </section>
        </div>
      </main>
    </>
  )
} 