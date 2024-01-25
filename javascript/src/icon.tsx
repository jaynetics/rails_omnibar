import {
  ArrowsRightLeftIcon,
  Cog6ToothIcon,
  CloudIcon,
  CommandLineIcon,
  DocumentIcon,
  HomeIcon,
  MagnifyingGlassIcon,
  QuestionMarkCircleIcon,
  UserIcon,
  SparklesIcon,
  WalletIcon,
  XMarkIcon,
} from "@heroicons/react/20/solid"

export const iconClass = (name: string | null | undefined) => {
  if (!name) return null

  if (name === "arrows") return ArrowsRightLeftIcon
  if (name === "cloud") return CloudIcon
  if (name === "cog") return Cog6ToothIcon
  if (name === "dev") return CommandLineIcon
  if (name === "document") return DocumentIcon
  if (name === "home") return HomeIcon
  if (name === "question") return QuestionMarkCircleIcon
  if (name === "search") return MagnifyingGlassIcon
  if (name === "sparkle") return SparklesIcon
  if (name === "user") return UserIcon
  if (name === "wallet") return WalletIcon
  if (name === "x") return XMarkIcon

  return null
}
