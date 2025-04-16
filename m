Return-Path: <linux-bcache+bounces-884-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A0C8A8AD4F
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 03:05:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2319A1903F38
	for <lists+linux-bcache@lfdr.de>; Wed, 16 Apr 2025 01:05:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092CB1FECCD;
	Wed, 16 Apr 2025 01:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eAgaZS00"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A6C20013A
	for <linux-bcache@vger.kernel.org>; Wed, 16 Apr 2025 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744765453; cv=none; b=VyCgimidIAC8SJPeu9EfRPOAS51kcKyxuvpY5aN9BGhkvxDv2ef6Cy5r6HGIpfSuArS30hdJ/BCrwEMkuc31jmVl/+JzAT+LpGqgATcczNyMLVi00RZ0uuf7/YNSmd5p4VbNhwYFx6WDi3dABtD6hUV57nb/Xr4TjUpYYJWN8m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744765453; c=relaxed/simple;
	bh=tPIIDWCtvCMUi0dba5wS/vnKRpQYieJRvDzGuUpS2cE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a1yuAea4QevdJVNPnLjw3mTQiIWcljCf8VA8Am8JSFMQ/at/dr2PZm8O5Wu0A3+OZaD789jSY4b8xTzzfyFWYSMQryuqvY+ip9sHmWsE7MfndfTBPiEypfGyG6JLRWS20nKs62afdFbINd1P5x0OYJCfoyydxYnadKSNIxzZLrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eAgaZS00; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-86192b6946eso108035339f.1
        for <linux-bcache@vger.kernel.org>; Tue, 15 Apr 2025 18:04:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744765451; x=1745370251; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOzygePW3310tVx7kEfO3x/NC5w6EQLjdhpFeXqXF04=;
        b=eAgaZS00Pv3pt+zm9nWLIo3Md/3MzJGcu7IEemdvbWpI7g/8GnXXX/9prjIrmZFNpp
         Yx4Htw3VJhzm7BtnAouIJxzAXGlZuFJIGChlAoN46/bEoFz0G1ccPFudxVd8oje4laAH
         z3B4qOUSqaxLNk0XssFvCcgGCvLwX2n0Or2XiASfBdJgF0WyJrYeXWMqL5qSw3OkgE0G
         ukMafe5GVGmEPlKGGQorH4xV7r0kR3cFxk6Mm6u7swaqflBIfofITIba8V6KsqrxDgAA
         6GOwl147a/5l+fIQF1AuyL13ayaZsPTxa0ZYQ9oi7yL6U4nkxoQGUaRJ7e2g1ZRM+iOH
         pU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744765451; x=1745370251;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOzygePW3310tVx7kEfO3x/NC5w6EQLjdhpFeXqXF04=;
        b=F2M+3OCBz81afWRnTeIDDq4w8w2MFcSGzA9A0dklQty/BRrStvbOIkTcntCMUEfRu/
         YDLlcGGon/FXB3aM+wTjIpbA4H7HSBq8X20RSXA8cmTBLLDKAgUXs4Hckmel2S2FERd5
         7l+QmQIt2r7vMKyXikAXtd8ca0ULqKKR19h86GH014Y7kqeTRAgMvwzqXgbXh8WC3l76
         WWo7PSxQPUc6q29HIj090PBH263KMv6falIBD0llDaiSLjzWdUaZbYot73PbLKDcAp6D
         dtq565EQh9yUVgT4nof8+rSlCqYUQMqNE8p8o1YT5q/jwhGMsLKhXVGIP3t8zc2dd7cs
         6Hrg==
X-Forwarded-Encrypted: i=1; AJvYcCVoLKU7udlRKhy+45fFPp4PBfQ1KCiv6p8Be5L1AGWB4Lvui9sWnZ4/cnnDQXTl22WZM+4wOV3g1dxqyjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFNrbUd0Q9K6OpfT8RAGE5a1CdsbLzJIdBuv8MWScmo0HM8q8r
	l6VpZXhWsmbo6TKJTK+CQOAFBL1Ged0Y+Kgz+09uJfE3HBzIJGWZF412hIp6o6o=
X-Gm-Gg: ASbGncvP1TJ4ZMeAy7e0ICdVp5KNDFnXen4NzPWxiy0uEA+JlOnNsJzyvV9SP29jjHR
	uO9r7gHgsVe4RJUa7eA0jzkOSSxiiE++J1gY6HKlbpTL/5Dg+DY4jqNbE8b8M7LHcWidQoP0IEs
	fGdvMzJlrw2DNoxyLML6x9m7cfcwNVSC4vNM4lbYcDomQQXmazzOBhawAriGlPm9936s8sjG1US
	5Sq3cqD91o0MsZvC4fkFMl26/MkP0h02mFtkgKCFGqwDbj61pnjfee/k1T/9RJ1dq3AS3GiOSR3
	XyNlj550hnqqIDDYpTeFvEk8zFimK3DM6qT0Jw==
X-Google-Smtp-Source: AGHT+IEHI5YXtsH3GtE+xAxjPnoEaxwITdOpITzfsT2ZontVDQfoJEe0M8gxlFjwjY706Hy1dO+lEg==
X-Received: by 2002:a05:6602:360f:b0:85e:8583:adc8 with SMTP id ca18e2360f4ac-861bfbbd3d6mr192307839f.3.1744765451183;
        Tue, 15 Apr 2025 18:04:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8616522cf6bsm275091139f.7.2025.04.15.18.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Apr 2025 18:04:10 -0700 (PDT)
Message-ID: <15e2151a-d788-48eb-8588-1d9a930c64dd@kernel.dk>
Date: Tue, 15 Apr 2025 19:04:09 -0600
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/11] pcache: Persistent Memory Cache for Block
 Devices
To: Dan Williams <dan.j.williams@intel.com>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, hch@lst.de,
 gregory.price@memverge.com, John@groves.net, Jonathan.Cameron@huawei.com,
 bbhushan2@marvell.com, chaitanyak@nvidia.com, rdunlap@infradead.org
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev
References: <20250414014505.20477-1-dongsheng.yang@linux.dev>
 <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <67fe9ea2850bc_71fe294d8@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/15/25 12:00 PM, Dan Williams wrote:
> Thanks for making the comparison chart. The immediate question this
> raises is why not add "multi-tree per backend", "log structured
> writeback", "readcache", and "CRC" support to dm-writecache?
> device-mapper is everywhere, has a long track record, and enhancing it
> immediately engages a community of folks in this space.

Strongly agree.

-- 
Jens Axboe

