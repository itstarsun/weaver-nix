package main

// Code generated by "weaver generate". DO NOT EDIT.
import (
	"context"
	"fmt"
	"github.com/ServiceWeaver/weaver/runtime/codegen"
	"go.opentelemetry.io/otel/codes"
	"go.opentelemetry.io/otel/trace"
	"reflect"
	"time"
)

func init() {
	codegen.Register(codegen.Registration{
		Name:     "github.com/itstarsun/weaver-nix/tests/hello/Service",
		Iface:    reflect.TypeOf((*Service)(nil)).Elem(),
		New:      func() any { return &impl{} },
		ConfigFn: func(i any) any { return i.(*impl).WithConfig.Config() },
		LocalStubFn: func(impl any, tracer trace.Tracer) any {
			return service_local_stub{impl: impl.(Service), tracer: tracer}
		},
		ClientStubFn: func(stub codegen.Stub, caller string) any {
			return service_client_stub{stub: stub, getArgsMetrics: codegen.MethodMetricsFor(codegen.MethodLabels{Caller: caller, Component: "github.com/itstarsun/weaver-nix/tests/hello/Service", Method: "GetArgs"}), getEnvMetrics: codegen.MethodMetricsFor(codegen.MethodLabels{Caller: caller, Component: "github.com/itstarsun/weaver-nix/tests/hello/Service", Method: "GetEnv"}), getConfigMetrics: codegen.MethodMetricsFor(codegen.MethodLabels{Caller: caller, Component: "github.com/itstarsun/weaver-nix/tests/hello/Service", Method: "GetConfig"})}
		},
		ServerStubFn: func(impl any, addLoad func(uint64, float64)) codegen.Server {
			return service_server_stub{impl: impl.(Service), addLoad: addLoad}
		},
	})
}

// Local stub implementations.

type service_local_stub struct {
	impl   Service
	tracer trace.Tracer
}

func (s service_local_stub) GetArgs(ctx context.Context) (r0 []string, err error) {
	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.tracer.Start(ctx, "main.Service.GetArgs", trace.WithSpanKind(trace.SpanKindInternal))
		defer func() {
			if err != nil {
				span.RecordError(err)
				span.SetStatus(codes.Error, err.Error())
			}
			span.End()
		}()
	}

	return s.impl.GetArgs(ctx)
}

func (s service_local_stub) GetEnv(ctx context.Context) (r0 []string, err error) {
	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.tracer.Start(ctx, "main.Service.GetEnv", trace.WithSpanKind(trace.SpanKindInternal))
		defer func() {
			if err != nil {
				span.RecordError(err)
				span.SetStatus(codes.Error, err.Error())
			}
			span.End()
		}()
	}

	return s.impl.GetEnv(ctx)
}

func (s service_local_stub) GetConfig(ctx context.Context) (r0 *Config, err error) {
	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.tracer.Start(ctx, "main.Service.GetConfig", trace.WithSpanKind(trace.SpanKindInternal))
		defer func() {
			if err != nil {
				span.RecordError(err)
				span.SetStatus(codes.Error, err.Error())
			}
			span.End()
		}()
	}

	return s.impl.GetConfig(ctx)
}

// Client stub implementations.

type service_client_stub struct {
	stub             codegen.Stub
	getArgsMetrics   *codegen.MethodMetrics
	getEnvMetrics    *codegen.MethodMetrics
	getConfigMetrics *codegen.MethodMetrics
}

func (s service_client_stub) GetArgs(ctx context.Context) (r0 []string, err error) {
	// Update metrics.
	start := time.Now()
	s.getArgsMetrics.Count.Add(1)

	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.stub.Tracer().Start(ctx, "main.Service.GetArgs", trace.WithSpanKind(trace.SpanKindClient))
	}

	defer func() {
		// Catch and return any panics detected during encoding/decoding/rpc.
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
		err = s.stub.WrapError(err)

		if err != nil {
			span.RecordError(err)
			span.SetStatus(codes.Error, err.Error())
			s.getArgsMetrics.ErrorCount.Add(1)
		}
		span.End()

		s.getArgsMetrics.Latency.Put(float64(time.Since(start).Microseconds()))
	}()

	var shardKey uint64

	// Call the remote method.
	s.getArgsMetrics.BytesRequest.Put(0)
	var results []byte
	results, err = s.stub.Run(ctx, 0, nil, shardKey)
	if err != nil {
		return
	}
	s.getArgsMetrics.BytesReply.Put(float64(len(results)))

	// Decode the results.
	dec := codegen.NewDecoder(results)
	r0 = serviceweaver_dec_slice_string_4af10117(dec)
	err = dec.Error()
	return
}

func (s service_client_stub) GetEnv(ctx context.Context) (r0 []string, err error) {
	// Update metrics.
	start := time.Now()
	s.getEnvMetrics.Count.Add(1)

	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.stub.Tracer().Start(ctx, "main.Service.GetEnv", trace.WithSpanKind(trace.SpanKindClient))
	}

	defer func() {
		// Catch and return any panics detected during encoding/decoding/rpc.
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
		err = s.stub.WrapError(err)

		if err != nil {
			span.RecordError(err)
			span.SetStatus(codes.Error, err.Error())
			s.getEnvMetrics.ErrorCount.Add(1)
		}
		span.End()

		s.getEnvMetrics.Latency.Put(float64(time.Since(start).Microseconds()))
	}()

	var shardKey uint64

	// Call the remote method.
	s.getEnvMetrics.BytesRequest.Put(0)
	var results []byte
	results, err = s.stub.Run(ctx, 2, nil, shardKey)
	if err != nil {
		return
	}
	s.getEnvMetrics.BytesReply.Put(float64(len(results)))

	// Decode the results.
	dec := codegen.NewDecoder(results)
	r0 = serviceweaver_dec_slice_string_4af10117(dec)
	err = dec.Error()
	return
}

func (s service_client_stub) GetConfig(ctx context.Context) (r0 *Config, err error) {
	// Update metrics.
	start := time.Now()
	s.getConfigMetrics.Count.Add(1)

	span := trace.SpanFromContext(ctx)
	if span.SpanContext().IsValid() {
		// Create a child span for this method.
		ctx, span = s.stub.Tracer().Start(ctx, "main.Service.GetConfig", trace.WithSpanKind(trace.SpanKindClient))
	}

	defer func() {
		// Catch and return any panics detected during encoding/decoding/rpc.
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
		err = s.stub.WrapError(err)

		if err != nil {
			span.RecordError(err)
			span.SetStatus(codes.Error, err.Error())
			s.getConfigMetrics.ErrorCount.Add(1)
		}
		span.End()

		s.getConfigMetrics.Latency.Put(float64(time.Since(start).Microseconds()))
	}()

	var shardKey uint64

	// Call the remote method.
	s.getConfigMetrics.BytesRequest.Put(0)
	var results []byte
	results, err = s.stub.Run(ctx, 1, nil, shardKey)
	if err != nil {
		return
	}
	s.getConfigMetrics.BytesReply.Put(float64(len(results)))

	// Decode the results.
	dec := codegen.NewDecoder(results)
	r0 = serviceweaver_dec_ptr_Config_e5ffca3f(dec)
	err = dec.Error()
	return
}

// Server stub implementations.

type service_server_stub struct {
	impl    Service
	addLoad func(key uint64, load float64)
}

// GetStubFn implements the stub.Server interface.
func (s service_server_stub) GetStubFn(method string) func(ctx context.Context, args []byte) ([]byte, error) {
	switch method {
	case "GetArgs":
		return s.getArgs
	case "GetEnv":
		return s.getEnv
	case "GetConfig":
		return s.getConfig
	default:
		return nil
	}
}

func (s service_server_stub) getArgs(ctx context.Context, args []byte) (res []byte, err error) {
	// Catch and return any panics detected during encoding/decoding/rpc.
	defer func() {
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
	}()

	// TODO(rgrandl): The deferred function above will recover from panics in the
	// user code: fix this.
	// Call the local method.
	r0, appErr := s.impl.GetArgs(ctx)

	// Encode the results.
	enc := codegen.NewEncoder()
	serviceweaver_enc_slice_string_4af10117(enc, r0)
	enc.Error(appErr)
	return enc.Data(), nil
}

func (s service_server_stub) getEnv(ctx context.Context, args []byte) (res []byte, err error) {
	// Catch and return any panics detected during encoding/decoding/rpc.
	defer func() {
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
	}()

	// TODO(rgrandl): The deferred function above will recover from panics in the
	// user code: fix this.
	// Call the local method.
	r0, appErr := s.impl.GetEnv(ctx)

	// Encode the results.
	enc := codegen.NewEncoder()
	serviceweaver_enc_slice_string_4af10117(enc, r0)
	enc.Error(appErr)
	return enc.Data(), nil
}

func (s service_server_stub) getConfig(ctx context.Context, args []byte) (res []byte, err error) {
	// Catch and return any panics detected during encoding/decoding/rpc.
	defer func() {
		if err == nil {
			err = codegen.CatchPanics(recover())
		}
	}()

	// TODO(rgrandl): The deferred function above will recover from panics in the
	// user code: fix this.
	// Call the local method.
	r0, appErr := s.impl.GetConfig(ctx)

	// Encode the results.
	enc := codegen.NewEncoder()
	serviceweaver_enc_ptr_Config_e5ffca3f(enc, r0)
	enc.Error(appErr)
	return enc.Data(), nil
}

// AutoMarshal implementations.

var _ codegen.AutoMarshal = &Config{}

func (x *Config) WeaverMarshal(enc *codegen.Encoder) {
	if x == nil {
		panic(fmt.Errorf("Config.WeaverMarshal: nil receiver"))
	}
	enc.String(x.Value)
}

func (x *Config) WeaverUnmarshal(dec *codegen.Decoder) {
	if x == nil {
		panic(fmt.Errorf("Config.WeaverUnmarshal: nil receiver"))
	}
	x.Value = dec.String()
}

// Encoding/decoding implementations.

func serviceweaver_enc_slice_string_4af10117(enc *codegen.Encoder, arg []string) {
	if arg == nil {
		enc.Len(-1)
		return
	}
	enc.Len(len(arg))
	for i := 0; i < len(arg); i++ {
		enc.String(arg[i])
	}
}

func serviceweaver_dec_slice_string_4af10117(dec *codegen.Decoder) []string {
	n := dec.Len()
	if n == -1 {
		return nil
	}
	res := make([]string, n)
	for i := 0; i < n; i++ {
		res[i] = dec.String()
	}
	return res
}

func serviceweaver_enc_ptr_Config_e5ffca3f(enc *codegen.Encoder, arg *Config) {
	if arg == nil {
		enc.Bool(false)
	} else {
		enc.Bool(true)
		(*arg).WeaverMarshal(enc)
	}
}

func serviceweaver_dec_ptr_Config_e5ffca3f(dec *codegen.Decoder) *Config {
	if !dec.Bool() {
		return nil
	}
	var res Config
	(&res).WeaverUnmarshal(dec)
	return &res
}
