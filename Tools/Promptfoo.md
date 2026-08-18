# Model Evaluation with Promptfoo

## Overview

This guide describes the manual evaluation setup using [promptfoo](https://promptfoo.dev), an open-source tool for testing and comparing LLM outputs across different models and prompts.

## What is Promptfoo?

Promptfoo is a tool that enables systematic testing and evaluation of Large Language Models (LLMs). It allows you to:

- Compare multiple models side-by-side
- Test different prompt variations
- Define automated assertions to validate outputs
- Use model-graded evaluations for subjective criteria
- Visualize results in an interactive web interface

## Installation Location

Promptfoo is installed in: `~/Simon/`

## Current Configuration

### Prompts

We test two prompt variations for tweet generation:

1. **Basic**: `"Write a tweet about {{topic}}"`
2. **Enhanced**: `"Write a concise, funny tweet about {{topic}}"`

### Models Under Evaluation

The following models are tested via OpenRouter:

| Provider | Model | Purpose |
|----------|-------|---------|
| Mistral AI | mistral-7b-instruct | Baseline small model |
| Mistral AI | mistral-small-creative | Creative variant |
| Anthropic | claude-sonnet-4.5 | High-quality reasoning |
| Anthropic | claude-haiku-4.5 | Fast, cost-effective |
| Google | gemini-3-flash-preview | Latest Google model |
| Moonshotai | kimi-k2.5 | Alternative provider |

### Test Cases

#### Test 1: Basic LLM Topic
- **Topic**: "llms"
- **Assertions**: None (manual review)

#### Test 2: Champagne Toast
- **Topic**: "Champagne toast"
- **Assertions**:
  - Output must contain the word "champagne" (case-insensitive)
  - Shorter outputs are preferred (scored by inverse length)

#### Test 3: Örebro
- **Topic**: "Örebro" (Swedish city)
- **Assertions**:
  - LLM-graded rubric: Output must be funny (evaluated by Claude Haiku 4.5)

## Commands

### Running Evaluations

```bash
# Navigate to the promptfoo directory
cd ~/Simon

# Run the evaluation
promptfoo eval

# View results in the web interface
promptfoo view
```

### Other Useful Commands

```bash
# Initialize a new configuration
promptfoo init

# Run evaluation and automatically open the viewer
promptfoo eval --view

# Export results to JSON
promptfoo eval --output results.json

# Run evaluation with a specific config file
promptfoo eval -c promptfoo.yaml

# Clear cache
promptfoo cache clear
```

## Workflow

1. **Define Test Cases**: Add new topics and assertions in `promptfoo.yaml`
2. **Run Evaluation**: Execute `promptfoo eval` from `~/Simon`
3. **Review Results**: Open the web viewer with `promptfoo view`
4. **Analyze**: Compare model outputs side-by-side
5. **Iterate**: Refine prompts and test cases based on findings

## Assertion Types

### Content Checks
- `icontains`: Case-insensitive substring match
- `contains`: Case-sensitive substring match
- `equals`: Exact match

### JavaScript Assertions
Custom logic for scoring outputs:
```yaml
- type: javascript
  value: 1 / (output.length + 1)  # Prefers shorter outputs
```

### LLM-Graded Rubrics
Use another LLM to evaluate subjective criteria:
```yaml
- type: llm-rubric
  value: ensure that the output is funny
  provider: openrouter:anthropic/claude-haiku-4.5
```

## Best Practices

1. **Start Simple**: Begin with basic test cases before adding complex assertions
2. **Use Diverse Topics**: Test edge cases and different domains
3. **Mix Assertion Types**: Combine objective checks with LLM-graded evaluations
4. **Document Expectations**: Add comments in the YAML to explain test rationale
5. **Version Control**: Keep `promptfoo.yaml` in git to track evaluation evolution

## Troubleshooting

### Environment Variables
Ensure OpenRouter API key is set:
```bash
export OPENROUTER_API_KEY="your-key-here"
```

### Common Issues
- **Timeouts**: Some models may be slow; increase timeout in config
- **Rate Limits**: OpenRouter has rate limits; space out evaluations if needed
- **Cache Issues**: Clear cache with `promptfoo cache clear`

## Resources

- [Promptfoo Documentation](https://promptfoo.dev/docs)
- [Configuration Guide](https://promptfoo.dev/docs/configuration/guide)
- [Assertion Reference](https://promptfoo.dev/docs/configuration/expected-outputs)
- [OpenRouter Documentation](https://openrouter.ai/docs)

---