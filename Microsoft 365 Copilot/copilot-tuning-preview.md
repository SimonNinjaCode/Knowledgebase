---
domain: m365-e7
id: "M365-COP-TUNE-001"
title: "Customize Microsoft 365 Copilot with Copilot Tuning (early access preview)"
sources: ["m365maps E7"]
ms-learn: "https://learn.microsoft.com/microsoft-365/copilot/copilot-tuning-process"
created: 2026-05-30
updated: 2026-05-30
type: concept
tags: ["#m365-e7", "#copilot", "#advanced"]
group: "advanced"
---

# Customize Microsoft 365 Copilot with Copilot Tuning (early access preview)

## Översikt

Copilot Tuning (preview) — en del av Microsoft 365 E7. Se [Microsoft Learn](https://learn.microsoft.com/microsoft-365/copilot/copilot-tuning-process) för full dokumentation.

## Innehåll

By using Microsoft 365 Copilot Tuning, organizations can tailor AI models to reflect their unique terminology, communication style, and business processes. When you fine-tune large language models (LLMs) with your own data, you can improve the accuracy, tone, and relevance of Copilot responses across your tenant.

Copilot Tuning goes beyond retention and retrieval to train tenant-specific LLMs on your organization\'s data while maintaining robust enterprise security, compliance, governance, and management controls. The LLMs are tuned for specific tasks like document summarization, document writing, expert answer, style editing, document validation, and optimization.

This article describes the process of tuning task-specific agents in Microsoft 365 Copilot for your organization.

Important

Microsoft 365 Copilot Tuning is currently available to a limited set of customers through early access programs. Access through [Frontier] is planned for April 2026. Features and requirements are subject to change.

## Fine-tuning process overview

To fine-tune AI models for your organization by using Copilot Tuning - Tune model, follow these training and tuning steps:

- **Task specific adaptation** - Prepare data for training. Each task has its own recipe for preparing the right organization data for the fine tuning.

- **Fine-tuning training** - Each task has its own recipe and fine tuning technique for the best outcome by using organization data. These techniques include, but aren\'t limited to, Supervised Fine Tuning (SFT), Reinforcement learning (RL), and Reasoning Fine Tuning (RFT). These recipes and techniques also evolve over time.

- **Evaluation** - Each task has its own recipes for how to evaluate the output by using rubrics defined by the organization.

[![Screenshot showing fine-tuning process.]][3]

The models that you tune are private. Your data isn\'t used to train general models for other tenants. All processing of your data is done in the tenant that only your authorized users have access to train and use. Specific individuals, typically administrators, have control over the training process.

## Task-specific adaptation

Task-specific adaptation occurs after you ingest your corpora. This adaptation involves processing the organization\'s content from its original format into a plain text format with one statement per line.

## Supervised fine-tuning

Use supervised fine-tuning to adapt a pretrained model to specific tasks or organizational requirements by training it on labeled input-output pairs. This process helps the model learn to produce responses that align with your organization\'s preferred formats, tone, and compliance needs. Supervised fine-tuning:

- Teaches structure and tone - Models learn how to respond in ways that reflect your organization\'s voice.
- Improves task accuracy - By training on high-quality examples, the model becomes more reliable for enterprise use cases.
- Supports compliance - You can train models to recognize and respond to regulatory language and internal classifications.

## Reinforcement learning

Use reinforcement learning as a post-training technique to tailor LLMs to your organization\'s unique communication style, tone, and tool usage preferences. Unlike supervised fine-tuning, which teaches the model to produce correct outputs from labeled examples, reinforcement learning optimizes for subjective qualities by learning from feedback signals.

Reinforcement learning is helpful when you want your model to:

- Reflect a specific tone of voice (empathetic, formal, concise).
- Prefer certain tools (such as Microsoft Graph APIs over RAG-based retrieval).
- Avoid retrieving content from sensitive sources (like ACL-tagged documents).
- Learn from user feedback to continuously improve.

*Se MS Learn för full dokumentation.*

## MS Learn-källa
[Copilot Tuning (preview)](https://learn.microsoft.com/microsoft-365/copilot/copilot-tuning-process)

## Relaterade notes
- Copilot Index
