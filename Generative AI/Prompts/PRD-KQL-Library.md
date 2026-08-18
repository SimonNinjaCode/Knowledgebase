# Deployment Platform

- **Vercel**: The application is configured for deployment on Vercel with custom routing rules defined in `vercel.json`.

---

# Development Environment

- **Vite**: Used as the build tool and development server  
- **TypeScript**: For type-safe code  
- **React 18**: For the UI component library  
- **Tailwind CSS**: For styling  
- **Path Aliases**: Configured with `@/` pointing to the `src` directory  

---

# Project Structure

```
├── src/
│   ├── components/           
│   │   ├── layout/           
│   │   │   ├── Header.tsx           # Application header with search and social icons
│   │   ├── ui/               
│   │   │   ├── Button.tsx           # Button component
│   │   │   ├── Card.tsx             # Card component
│   │   │   ├── CopyButton.tsx       # Copy-to-clipboard button 
│   │   │   └── SocialIcons.tsx      # Social media icon components
│   │   ├── QueryDisplay.tsx         # Content display component
│   │   └── SearchModal.tsx          # Search functionality
│   ├── lib/                  
│   │   └── utils.ts                 # Shared utility functions
│   ├── types/                
│   │   └── index.ts                 # Main type definitions
│   ├── app.tsx                      # Main application component
│   ├── index.css                    # Global CSS
│   └── main.tsx                     # Application entry point
├── .gitattributes                  # Git attributes file
├── README.md                       # Project documentation
├── package.json                    # Project dependencies and scripts
├── postcss.config.js               # PostCSS configuration
├── tailwind.config.ts              # Tailwind CSS configuration
├── tsconfig.json                   # TypeScript configuration
├── vercel.json                     # Vercel deployment configuration
└── vite.config.ts                  # Vite configuration
```

---

# Core Features

## Header Component

The `Header` component (`src/components/layout/Header.tsx`) includes:

- Application title/logo  
- Search button that opens the search modal  
- Social media icons (Twitter/X, Bluesky, LinkedIn, Email, GitHub)  

```tsx
<header className="bg-gray-900 border-b border-gray-800 py-4 px-4">
  <div className="container mx-auto flex items-center justify-between">
    <h1 className="text-2xl font-bold bg-gradient-to-r from-orange-400 to-orange-600 text-transparent bg-clip-text">
      KQL Library
    </h1>
    <div className="flex items-center gap-3">
      <Button> 
        <Search className="w-5 h-5" />
      </Button>

      {/* Social Media Icons */}
      <SocialIcon type="twitter" href="..." />
      <SocialIcon type="bluesky" href="..." />
      <SocialIcon type="linkedin" href="..." />
      <SocialIcon type="mail" href="..." />
      <SocialIcon type="github" href="..." />
    </div>
  </div>
</header>
```

---

## Search Functionality

The `SearchModal` component provides:

- Full-text search across titles, descriptions, and tags  
- Category/subcategory filtering  
- Keyboard shortcuts (Escape to close, Enter to select)  

---

## Key Components

### App Component (`app.tsx`)

The main application component handles:

- Data fetching and loading state  
- Category and query selection logic  
- Search state  
- Main layout structure  

---

## UI Components

- **Button**: Reusable button with variant support  
- **Card**: Container component for content  
- **CopyButton**: Button with copy functionality and success animation  
- **SocialIcons**: SVG social media icons with standardized styling  

---

## Layout Components

- **Header**: Application header with search and social links  

---
