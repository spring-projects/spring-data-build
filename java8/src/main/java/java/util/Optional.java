/*
 * Copyright 2014 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package java.util;

/**
 * Stub implementation of JDK 8's {@link Optional}.
 * 
 * @author Oliver Gierke
 */
@SuppressWarnings("unused")
public final class Optional<T> {

	private static final Optional<?> EMPTY = new Optional<Object>(null);

	private final T value;

	private Optional(T value) {
		this.value = value;
	}

	public static <T> Optional<T> of(T value) {
		return new Optional<T>(value);
	}

	public static <T> Optional<T> ofNullable(T value) {
		return value == null ? Optional.<T> empty() : of(value);
	}

	@SuppressWarnings("unchecked")
	public static <T> Optional<T> empty() {
		Optional<T> t = (Optional<T>) EMPTY;
		return t;
	}
}
