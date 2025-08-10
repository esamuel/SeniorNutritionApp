export interface Author {
  name: string
  image?: string
  bio?: string
}

export interface BlogPost {
  slug: string
  title: string
  description: string
  date: string
  author: Author
  content: string
  category: string
  tags: string[]
  image?: string
  readingTime?: string
}

export interface BlogCategory {
  name: string
  description: string
  slug: string
  postCount: number
} 