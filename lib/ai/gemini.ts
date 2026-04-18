import { GoogleGenerativeAI } from "@google/generative-ai";

export async function generateHistoricalContext(person: any, contextType: string): Promise<string> {
  if (!process.env.GEMINI_API_KEY) throw new Error("GEMINI_API_KEY is not configured");

  const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
  const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

  const birthYear = person.birth_date?.match(/\d{4}/)?.[0];
  const deathYear = person.death_date?.match(/\d{4}/)?.[0];
  const place = person.birth_place?.name ?? person.birth_place?.municipality ?? "the Caribbean";
  const name = `${person.first_name}${person.last_name_paternal ? " " + person.last_name_paternal : ""}`;
  const raceNote = person.racial_status_historical
    ? ` Historical racial classification recorded as: ${person.racial_status_historical}.`
    : "";

  const prompt =
    contextType === "historical_snapshot"
      ? `You are a genealogy historian writing for a family legacy platform.

${name} was born ${birthYear ? `around ${birthYear}` : "at an unknown date"} in ${place}.${deathYear ? ` They died around ${deathYear}.` : ""}${raceNote}

Write a warm, compelling 3-paragraph historical snapshot for their family members to read:
1. What life was like in ${place} during their birth year — the political situation, social conditions, and what daily life looked like for someone of their background
2. The major historical events they lived through across their lifetime
3. How their personal story fits into the broader arc of their community's history

Tone: warm and engaging, written for a family audience discovering their heritage. Factual, respectful, educational. Three short paragraphs, no headers, no bullet points.`
      : `Write a 2-paragraph educational note about ${name} from ${place}${birthYear ? ` (born ~${birthYear})` : ""}. Warm, informative tone for a family genealogy platform.`;

  const result = await model.generateContent(prompt);
  return result.response.text();
}
