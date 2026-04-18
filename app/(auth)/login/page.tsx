import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

import { signIn } from "./actions";

export default function LoginPage({
  searchParams,
}: {
  searchParams?: { error?: string };
}) {
  return (
    <div className="flex min-h-screen items-center justify-center bg-background px-4">
      <Card className="w-full max-w-sm border-stone-300/80 bg-white/90 shadow-2xl shadow-amber-950/10 dark:border-stone-800 dark:bg-stone-900/90 dark:shadow-black/30">
        <CardHeader className="space-y-1">
          <CardTitle className="font-serif text-2xl text-stone-900 dark:text-stone-100">
            Family Legacy
          </CardTitle>
          <CardDescription className="text-stone-600 dark:text-stone-400">
            Sign in to access your family archive
          </CardDescription>
        </CardHeader>
        <CardContent>
          {searchParams?.error ? (
            <p className="mb-4 rounded-md border border-red-200 bg-red-50 px-3 py-2 text-sm text-red-700 dark:border-red-900/60 dark:bg-red-950/40 dark:text-red-300">
              {searchParams.error}
            </p>
          ) : null}
          <form action={signIn} className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="email" className="text-stone-700 dark:text-stone-300">
                Email
              </Label>
              <Input
                id="email"
                name="email"
                type="email"
                required
                className="border-stone-300 bg-stone-50 text-stone-900 dark:border-stone-700 dark:bg-stone-800 dark:text-stone-100"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="password" className="text-stone-700 dark:text-stone-300">
                Password
              </Label>
              <Input
                id="password"
                name="password"
                type="password"
                required
                className="border-stone-300 bg-stone-50 text-stone-900 dark:border-stone-700 dark:bg-stone-800 dark:text-stone-100"
              />
            </div>
            <Button
              type="submit"
              className="w-full bg-amber-700 text-white hover:bg-amber-600 dark:bg-amber-700 dark:hover:bg-amber-600"
            >
              Sign In
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
