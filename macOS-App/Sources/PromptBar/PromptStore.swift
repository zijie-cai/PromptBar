import SwiftUI

class PromptStore: ObservableObject {
    @Published var prompts: [Prompt] = [
        Prompt(emoji: "🧠", title: "Blog Writer", description: "Write a structured blog post about a topic.", content: "Write a comprehensive, engaging, and well-structured blog post about [TOPIC]. Include an introduction, several main points with subheadings, and a strong conclusion. Keep the tone [TONE].", category: "Writing", isFavorite: true),
        Prompt(emoji: "✉️", title: "Friendly Email Draft", description: "Draft a polite professional email.", content: "Draft a polite and professional email to [RECIPIENT] regarding [SUBJECT]. The main goal of the email is to [GOAL]. Keep it concise and friendly.", category: "Communication", isFavorite: true),
        Prompt(emoji: "💻", title: "Debug Code", description: "Analyze and fix bugs in code.", content: "Please review the following code snippet. Identify any bugs, performance issues, or security vulnerabilities. Provide the corrected code and explain the changes made:\n\n[CODE]", category: "Development", isFavorite: false),
        Prompt(emoji: "📈", title: "Product Strategy", description: "Generate a product roadmap outline.", content: "Create a high-level product roadmap outline for a [PRODUCT_TYPE] aimed at [TARGET_AUDIENCE]. Include key phases: Discovery, MVP, V1, and Future Iterations. List 3-5 major features per phase.", category: "Business", isFavorite: false),
        Prompt(emoji: "📝", title: "Summarize Article", description: "Extract key points from text.", content: "Summarize the following article in 3-5 bullet points. Focus on the main arguments and key takeaways. Keep each bullet point under 2 sentences:\n\n[ARTICLE_TEXT]", category: "Research", isFavorite: true),
        Prompt(emoji: "🔍", title: "Research Assistant", description: "Gather facts and sources on a topic.", content: "Act as a research assistant. Provide a detailed overview of [TOPIC]. Include historical context, current trends, and potential future developments. Cite your sources or mention where this information is typically found.", category: "Research", isFavorite: false)
    ]
    
    init() {
        sortPrompts()
    }
    
    func sortPrompts() {
        prompts.sort { p1, p2 in
            if p1.isFavorite && !p2.isFavorite { return true }
            if !p1.isFavorite && p2.isFavorite { return false }
            return p1.title < p2.title
        }
    }
}
