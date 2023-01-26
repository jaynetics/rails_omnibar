import {EffectCallback, useCallback, useEffect, useRef} from "preact/hooks"
import debounce from "lodash.debounce"

export function useDebouncedEffect(
  effect: EffectCallback,
  deps: any[],
  wait = 300
) {
  const cleanUp = useRef<void | (() => void)>()
  const effectRef = useRef<EffectCallback>()
  const updatedEffect = useCallback(effect, deps)
  effectRef.current = updatedEffect
  const lazyEffect = useCallback(
    debounce(() => {
      cleanUp.current = effectRef.current?.()
    }, wait),
    []
  )
  useEffect(lazyEffect, deps)
  useEffect(() => {
    return () => {
      cleanUp.current instanceof Function ? cleanUp.current() : undefined
    }
  }, [])
}
