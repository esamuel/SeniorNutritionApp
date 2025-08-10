import { Metadata } from 'next'
import { getAllPosts } from '../utils/loadPosts'
import Image from 'next/image'
import Link from 'next/link'
import Navbar from "../../components/Navbar";
import { MDXRemote } from 'next-mdx-remote/rsc'
import { compileMDX } from 'next-mdx-remote/rsc'

interface Props {
  params: {
    slug: string
  }
}

export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const posts = getAllPosts()
  const post = posts.find(p => p.slug === params.slug)
  
  if (!post) {
    return {
      title: 'Post Not Found',
    }
  }

  return {
    title: `${post.title} - Senior Nutrition Blog`,
    description: post.description,
  }
}

const components = {
  h1: (props: any) => <h1 className="text-3xl font-bold text-gray-900 mt-8 mb-6 leading-tight" {...props} />,
  h2: (props: any) => <h2 className="text-2xl font-semibold text-gray-800 mt-8 mb-4 leading-snug border-l-4 border-blue-500 pl-4" {...props} />,
  h3: (props: any) => <h3 className="text-xl font-medium text-gray-700 mt-6 mb-3 leading-relaxed" {...props} />,
  p: (props: any) => <p className="mb-4 text-gray-700 leading-relaxed" {...props} />,
  ul: (props: any) => <ul className="mb-6 ml-4 space-y-2 list-disc list-inside" {...props} />,
  ol: (props: any) => <ol className="mb-6 ml-4 space-y-2 list-decimal list-inside" {...props} />,
  li: (props: any) => <li className="mb-2 text-gray-700" {...props} />,
  strong: (props: any) => <strong className="font-semibold text-gray-900" {...props} />,
  em: (props: any) => <em className="italic text-gray-700" {...props} />,
  blockquote: (props: any) => <blockquote className="border-l-4 border-gray-300 pl-4 py-2 my-6 text-gray-600 italic" {...props} />,
}

export default function BlogPost({ params }: Props) {
  const posts = getAllPosts()
  const post = posts.find(p => p.slug === params.slug)

  if (!post) {
    return (
      <>
        <Navbar />
        <main className="min-h-screen pt-24 pb-12 px-4 sm:px-6 lg:px-8">
          <div className="max-w-3xl mx-auto">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              Post Not Found
            </h1>
            <Link href="/blog" className="text-blue-600 hover:text-blue-800">
              ← Back to Blog
            </Link>
          </div>
        </main>
      </>
    )
  }

  return (
    <>
      <Navbar />
      <main className="min-h-screen pt-24 pb-12 px-4 sm:px-6 lg:px-8">
        <article className="max-w-3xl mx-auto">
          <Link href="/blog" className="text-blue-600 hover:text-blue-800 mb-8 block">
            ← Back to Blog
          </Link>

          {post.image && (
            <div className="relative h-64 w-full mb-8 rounded-lg overflow-hidden bg-gray-100">
              <Image
                src={post.image}
                alt={post.title}
                fill
                className="object-cover"
                sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
                priority
              />
            </div>
          )}
          {!post.image && (
            <div className="h-64 w-full mb-8 rounded-lg bg-gradient-to-r from-blue-100 to-green-100 flex items-center justify-center">
              <span className="text-gray-600 text-lg">📚 Blog Article</span>
            </div>
          )}

          <div className="mb-8">
            <h1 className="text-4xl font-bold text-gray-900 mb-4">
              {post.title}
            </h1>
            
            <div className="flex items-center gap-4 text-gray-600">
              <div className="flex items-center gap-2">
                {post.author?.image && (
                  <Image
                    src={post.author.image}
                    alt={post.author.name}
                    width={24}
                    height={24}
                    className="rounded-full"
                  />
                )}
                <span>{post.author?.name || 'Anonymous'}</span>
              </div>
              <span>•</span>
              <time>
                {new Date(post.date).toLocaleDateString('en-US', {
                  month: 'long',
                  day: 'numeric',
                  year: 'numeric'
                })}
              </time>
              <span>•</span>
              <span>{post.readingTime || '5 min read'}</span>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm border border-gray-100 p-8 mb-8">
            <div className="prose prose-lg max-w-none text-base leading-relaxed">
              <MDXRemote source={post.content} components={components} />
            </div>
          </div>
          
          {/* Reading Progress Indicator */}
          <div className="mb-8 p-4 bg-blue-50 rounded-lg border-l-4 border-blue-400">
            <div className="flex items-center space-x-3">
              <div className="flex-shrink-0">
                <svg className="h-5 w-5 text-blue-500" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clipRule="evenodd" />
                </svg>
              </div>
              <div>
                <p className="text-sm font-medium text-blue-900">
                  Great job reading this article! 
                </p>
                <p className="text-sm text-blue-700">
                  Remember to consult with your healthcare provider before making significant changes to your health routine.
                </p>
              </div>
            </div>
          </div>

          <div className="mt-12 pt-8 border-t border-gray-200 bg-gray-50 rounded-lg p-6">
            <h2 className="text-2xl font-semibold text-gray-900 mb-6 flex items-center">
              <svg className="h-6 w-6 text-blue-500 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
              </svg>
              About the Author
            </h2>
            <div className="flex items-start gap-6">
              <div className="flex-shrink-0">
                {post.author?.image ? (
                  <Image
                    src={post.author.image}
                    alt={post.author.name}
                    width={80}
                    height={80}
                    className="rounded-full border-4 border-white shadow-md"
                  />
                ) : (
                  <div className="w-20 h-20 bg-gradient-to-br from-blue-400 to-blue-600 rounded-full flex items-center justify-center border-4 border-white shadow-md">
                    <svg className="h-10 w-10 text-white" fill="currentColor" viewBox="0 0 20 20">
                      <path fillRule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clipRule="evenodd" />
                    </svg>
                  </div>
                )}
              </div>
              <div className="flex-1">
                <h3 className="text-lg font-semibold text-gray-900 mb-2">
                  {post.author?.name || 'Anonymous'}
                </h3>
                {post.author?.bio && (
                  <p className="text-gray-600 leading-relaxed mb-4">{post.author.bio}</p>
                )}
                <div className="flex items-center text-sm text-gray-500">
                  <svg className="h-4 w-4 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                  </svg>
                  Published on {new Date(post.date).toLocaleDateString('en-US', {
                    month: 'long',
                    day: 'numeric',
                    year: 'numeric'
                  })}
                </div>
              </div>
            </div>
          </div>
          
          {/* Related Articles Suggestion */}
          <div className="mt-8 p-6 bg-gradient-to-r from-green-50 to-blue-50 rounded-lg border border-green-200">
            <h3 className="text-lg font-semibold text-gray-900 mb-3 flex items-center">
              <svg className="h-5 w-5 text-green-500 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
              Keep Learning
            </h3>
            <p className="text-gray-700 mb-4">
              Want to learn more about senior health and nutrition? Check out our other articles for more expert tips and guidance.
            </p>
            <Link 
              href="/blog" 
              className="inline-flex items-center px-4 py-2 bg-blue-600 text-white text-sm font-medium rounded-md hover:bg-blue-700 transition-colors"
            >
              Browse All Articles
              <svg className="ml-2 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
              </svg>
            </Link>
          </div>
        </article>
      </main>
    </>
  )
} 