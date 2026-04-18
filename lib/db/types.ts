export type Confidence = "confirmed" | "likely" | "possible" | "speculative";
export type DateConfidence = "exact" | "approximate" | "estimated" | "unknown";

export interface Person {
  id: string;
  first_name: string;
  middle_name: string | null;
  last_name_paternal: string | null;
  last_name_maternal: string | null;
  display_name: string;
  alternate_names: string[] | null;
  gender: "male" | "female" | "unknown";
  birth_date: string | null;
  birth_date_confidence: DateConfidence;
  birth_place_id: string | null;
  death_date: string | null;
  death_date_confidence: DateConfidence;
  death_place_id: string | null;
  biography: string | null;
  racial_status_historical: string | null;
  occupation: string | null;
  confidence: Confidence;
  is_anchor: boolean;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Relationship {
  id: string;
  person_a_id: string;
  person_b_id: string;
  relationship_type:
    | "parent"
    | "child"
    | "spouse"
    | "sibling"
    | "half_sibling"
    | "enslaved_by"
    | "godparent"
    | "godchild"
    | "other";
  confidence: Confidence;
  start_date: string | null;
  end_date: string | null;
  notes: string | null;
  created_at: string;
}

export interface Place {
  id: string;
  name: string;
  municipality: string | null;
  region: string | null;
  country: string;
  barrio: string | null;
  lat: number | null;
  lng: number | null;
  notes: string | null;
  created_at: string;
}

export type DocumentType =
  | "birth_certificate"
  | "death_certificate"
  | "marriage_record"
  | "baptism_record"
  | "church_record"
  | "census_record"
  | "slave_register"
  | "emancipation_record"
  | "land_record"
  | "photograph"
  | "handwritten_note"
  | "newspaper"
  | "other";

export interface Document {
  id: string;
  title: string;
  document_type: DocumentType;
  document_date: string | null;
  document_date_confidence: DateConfidence;
  place_id: string | null;
  source_name: string | null;
  source_url: string | null;
  source_reference: string | null;
  original_language: string;
  original_text: string | null;
  corrected_text: string | null;
  summary: string | null;
  storage_path: string | null;
  mime_type: string | null;
  confidence: Confidence;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface Event {
  id: string;
  person_id: string | null;
  event_type:
    | "birth"
    | "baptism"
    | "marriage"
    | "death"
    | "residence"
    | "census"
    | "emancipation"
    | "enslavement"
    | "labor"
    | "migration"
    | "land_transaction"
    | "other";
  event_date: string | null;
  event_date_confidence: DateConfidence;
  place_id: string | null;
  description: string | null;
  document_id: string | null;
  confidence: Confidence;
  notes: string | null;
  created_at: string;
}

export interface Hypothesis {
  id: string;
  title: string;
  description: string | null;
  hypothesis_type: string | null;
  status: "open" | "confirmed" | "likely" | "possible" | "disproven";
  people_involved: string[] | null;
  documents_involved: string[] | null;
  next_steps: string | null;
  notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface ResearchTask {
  id: string;
  title: string;
  description: string | null;
  status: "todo" | "in_progress" | "done" | "blocked";
  priority: "high" | "medium" | "low";
  related_person_id: string | null;
  related_document_id: string | null;
  due_date: string | null;
  notes: string | null;
  created_at: string;
}
