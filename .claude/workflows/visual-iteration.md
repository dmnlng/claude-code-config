# Visual Iteration Workflow

Rapidly iterate on UI/visual design with Claude Code using screenshots and design mocks.

## Overview

Claude is multimodal and can see images. This enables powerful visual development workflows:
- Implement designs from mockups
- Debug visual issues from screenshots
- Iterate on styling until pixel-perfect
- Compare before/after visual states

## Workflow: Design Mock to Implementation

### 1. Provide Design Reference

**Share the design mock with Claude:**

```
I have a design mock for the login page. Here's the image: [paste/upload image]

Please implement this design.
```

**Or via file path:**
```
Implement the design shown in designs/login-mockup.png
```

### 2. Initial Implementation

Claude will:
- Analyze the visual design
- Identify components, layout, colors, typography
- Implement HTML/CSS or component code
- Match proportions, spacing, and styling

### 3. Visual Verification

**Generate a screenshot to compare:**

**Option A: Using Puppeteer MCP**
```
Use Puppeteer to screenshot the login page and compare it to the mock
```

**Option B: Manual screenshot**
```
I've taken a screenshot of the current implementation: [paste image]

What differs from the original mock?
```

**Option C: iOS Simulator MCP**
```
Take a screenshot from the iOS simulator and analyze differences
```

### 4. Iterative Refinement

Claude will identify differences:
- "The button padding is too small"
- "The logo should be 20% larger"
- "The blue is slightly darker in the mock"
- "Spacing between form fields should be 24px not 16px"

**Claude will iterate and ask for another screenshot:**
```
I've adjusted those issues. Please take another screenshot to verify.
```

### 5. Convergence (2-3 Iterations)

Like humans, Claude's visual matching improves with feedback:
- **Iteration 1**: Gets basic structure right (~70% match)
- **Iteration 2**: Refines spacing, colors, sizes (~90% match)
- **Iteration 3**: Pixel-perfect adjustments (~98% match)

## Workflow: Visual Bug Fixing

### 1. Report Issue with Screenshot

```
The navigation menu is overlapping the content on mobile.
Here's a screenshot: [paste image]
```

### 2. Claude Diagnoses

Claude analyzes the screenshot:
- Identifies z-index issues
- Spots CSS overflow problems
- Detects responsive breakpoint failures
- Notices alignment issues

### 3. Fix and Verify

```
I've fixed the z-index and added proper media queries.
Please test on mobile and send another screenshot.
```

## Best Practices

### 1. High-Quality Screenshots

**Good:**
- Full resolution
- Shows complete relevant area
- Includes context (browser window, device frame)
- Multiple breakpoints if responsive

**Avoid:**
- Cropped screenshots missing context
- Low resolution images
- Screenshots of screenshots (quality loss)

### 2. Annotated Mockups

If possible, annotate designs with:
- Exact color values (#3B82F6)
- Spacing measurements (16px, 2rem)
- Font specifications (Inter, 14px, 500 weight)
- Component states (hover, active, disabled)

### 3. Multiple Viewports

For responsive designs:
```
Here are screenshots at three breakpoints:
- Mobile (375px): [image]
- Tablet (768px): [image]
- Desktop (1920px): [image]
```

### 4. Show Interactions

For interactive elements:
```
Here's the button in three states:
- Default: [image]
- Hover: [image]
- Active: [image]
```

## Advanced Techniques

### A/B Design Comparison

```
I have two design options for the dashboard:
- Option A: [image]
- Option B: [image]

Please implement both so we can compare them side-by-side.
```

### Design System Extraction

```
Here are screenshots of 10 pages from our app: [images]

Analyze these and extract the design system: colors, typography,
spacing scale, and common component patterns.
```

### Accessibility via Visual Analysis

```
Screenshot: [image]

Check this design for accessibility issues:
- Color contrast ratios
- Touch target sizes
- Visual hierarchy
```

## Tools Integration

### Puppeteer MCP

```bash
# In .claude/settings.local.json or .mcp.json
{
  "mcpServers": {
    "puppeteer": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-puppeteer"]
    }
  }
}
```

Usage:
```
Use Puppeteer to:
1. Navigate to http://localhost:3000/dashboard
2. Take a full-page screenshot
3. Compare to designs/dashboard-mock.png
```

### iOS Simulator MCP

For mobile app development:
```
Launch iOS Simulator, navigate to the profile screen,
and take a screenshot for comparison
```

### Browser DevTools Screenshots

Claude can guide you:
```
Open DevTools, click the device toolbar, select iPhone 12,
and take a screenshot with Cmd+Shift+P > "Capture screenshot"
```

## Example: Complete Visual Iteration Session

```
User: I need to implement this hero section design [shares Figma mockup]

Claude: I can see a hero section with:
- Large heading "Welcome to our platform"
- Centered layout
- Gradient background (purple to blue)
- CTA button (rounded, white text)
- Illustration on the right

Let me implement this...

[Claude writes HTML/CSS code]

Claude: I've created the hero section. Please take a screenshot
so I can compare it to your mock.

User: [shares screenshot]

Claude: I see several differences:
1. The heading font size is too small (should be ~48px)
2. The gradient angle is wrong (should be 135deg not 90deg)
3. The illustration needs 40px more margin on the right
4. The button border-radius should be larger

Let me adjust these...

[Claude updates code]

Claude: Please take another screenshot.

User: [shares screenshot]

Claude: Much better! Just two minor tweaks:
1. The heading letter-spacing needs to be tighter (-0.02em)
2. The button box-shadow is missing

[Claude fine-tunes]

Claude: This should now match your design. Please verify with
a final screenshot.

User: [shares screenshot] Perfect!

Claude: Great! The implementation now matches your design mock.
Should I commit these changes?
```

## Troubleshooting

### Claude Can't See the Image

Ensure:
- Image is properly uploaded/pasted
- File path is correct and accessible
- Image format is supported (PNG, JPG, WebP, SVG)

### Iterations Not Converging

Try:
- Be more specific about differences
- Provide exact measurements
- Share the original design file format if possible
- Annotate screenshots with arrows/highlights

### Performance with Large Images

- Optimize images before sharing (< 5MB ideal)
- Crop to relevant areas
- Use appropriate resolution (Retina not always needed)

## Resources

- Figma Dev Mode for exact measurements
- Browser DevTools for CSS inspection
- Design token documentation
- Accessibility checker tools

---

**Pro Tip**: Like pair programming, visual iteration works best with quick feedback loops. Take screenshots frequently and provide specific feedback for fastest convergence.
