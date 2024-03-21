Return-Path: <linux-bcache+bounces-354-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 662D7881CC5
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 08:13:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9183B1C20E3D
	for <lists+linux-bcache@lfdr.de>; Thu, 21 Mar 2024 07:13:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00C9450249;
	Thu, 21 Mar 2024 07:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WAkr4p5p"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7224D9F4;
	Thu, 21 Mar 2024 07:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711005224; cv=none; b=L1fxzkZOx2z3NL9mazCpJWpZvY6qEC69Iqk5yJ+L2WkyLY/9HDy7UsjapwACkIKtfmlRgWElGAvb5cTLN9y/Yv9nQ+n/tMJVTvcqg01CHA/13Dvfhl8RUXeRjrwkaMELGG7K98Vm3roulKwKtkGJxdoWKPF6qeCkqmv7RjT0O24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711005224; c=relaxed/simple;
	bh=44fOfPf5fU3d/qtrVfcQjK72mdFuP0xwwcj4hJus11M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHGrXoXAXPemhyaba0lGJnMECaofWg3flpQ/iVhFVVPj61ej+7WF2uhVTuiOtuCirm4iydpwBChYoOzK+AB48wxSEfYN/R7MiPPT5nTWUNpkUqFaUjaEynoTHctBWkM7agEVO6M38lXOFvplmuTeydfplUphaV1HlykO0aNv5NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WAkr4p5p; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6e681fad78cso41335a34.0;
        Thu, 21 Mar 2024 00:13:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711005222; x=1711610022; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cdehVXsBNnGNu7JIAl0Q10r3P3hbg+hd7rOHH7Isw/s=;
        b=WAkr4p5pGFEZE01ofTZRXyHCPYKnM5Y5EWwj1ApBYV7uDPELSctmDFdPCpALavxXQc
         5UOOO4+hMzl9syYiKtJkbfltepvyX9fMKrTQ1TV9UQYnKlxcN70yikuw2qQpjvyvaw7F
         6vHquB5mwWxw0sWAMfHOsVX4pfg8zKVWCo/uHcN0Wli6JFmqfxABaFppmqM+7WCPfeGo
         aKpEHZSOjUwBOYLJE3oBDiwPwe2pQJFokLRA9As7PNahJq1P5oan/jj1yftTrUyIqqGV
         U6+nNfT2EKbG10f2QuKDyaVbNHknWGC7sjuanSz9je4urfVmqI4vYC7D6XejMBmPYWnE
         qhKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711005222; x=1711610022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cdehVXsBNnGNu7JIAl0Q10r3P3hbg+hd7rOHH7Isw/s=;
        b=blv4pZcQnKBt9Nw44+Ky1ZhV6ClSNx8tm+xGU/OVq9JP07wmnavB0BaAjcRJA4KwyL
         wZkj/Lcy+ynTvyRJws3UNskHNssEWvxFn6O57HYl8Tubv1SgqV7FXJhLVJqGN0dDE0WY
         QHKTm5JRP4AZeRU7fzyBGg6uT0kcuYgitICRI9qUeQfruh48YXVL4txz3dD7jTQkZkQl
         ZkkuzIMHMF6bWEFXSUL2S4YopdoXemTBLzfYh2TKZ9lKTvuMWsJ5+7yRJhOsLZKkBl19
         GkKEPfLbPrRsqD/rcN/Epo0p02SAL1VtJrPQYhE1RhQCP8SSA8aZHwL8IPX2/5+JW6Gr
         FlZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIjWEq8Xk0UJrpUOaCng8hXQuntltLRejUdtt6bc0PBDuNnsUe2AmWnTwxyrZtT81s3vBxDiv2fT85tQhNn29xkf072NfZqDglANCSCyXno6Wfj1xIPsLqDNzns8CTNmNrnq5p3Ze/hiPJNBFI3MDRbIg5qYtj54sK6Aa8CDpsoqRYrgYPaoEkyiCBfMQzzJICkZ5kIayUpoVZXIEybc/3oRIS16Bn+UF4IcB0
X-Gm-Message-State: AOJu0YzlHvh1m4s6qbNw8c5+48U2hZQaFlQOmWJ5uDJQ3mnlhcruQ+9j
	entkgQ/6x3YASD2/CH/hA7uwsKPUnIhkWBbgeFL2YHCHbXjl8B3WFKlkJa63Ta8=
X-Google-Smtp-Source: AGHT+IFyBPQ76yKJTbUwHPEhA91L3Dj58RUYtEkSZ5tRp1ui+ThKUlnlraJbQqHDTO2KCUJcjGoqYQ==
X-Received: by 2002:a05:6a21:a59c:b0:1a3:6f13:b136 with SMTP id gd28-20020a056a21a59c00b001a36f13b136mr8311254pzc.6.1711004907652;
        Thu, 21 Mar 2024 00:08:27 -0700 (PDT)
Received: from visitorckw-System-Product-Name ([140.113.216.168])
        by smtp.gmail.com with ESMTPSA id y10-20020a17090322ca00b001e04cfa5e8csm4711690plg.99.2024.03.21.00.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 00:08:27 -0700 (PDT)
Date: Thu, 21 Mar 2024 15:08:22 +0800
From: Kuan-Wei Chiu <visitorckw@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: colyli@suse.de, msakai@redhat.com, peterz@infradead.org,
	mingo@redhat.com, acme@kernel.org, namhyung@kernel.org,
	akpm@linux-foundation.org, bfoster@redhat.com, mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com, jolsa@kernel.org,
	irogers@google.com, adrian.hunter@intel.com, jserv@ccns.ncku.edu.tw,
	dm-devel@lists.linux.dev, linux-bcache@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 00/15] treewide: Refactor heap related implementation
Message-ID: <Zfvc5iqc+BN6v2Oj@visitorckw-System-Product-Name>
References: <20240320145417.336208-1-visitorckw@gmail.com>
 <ofjgwiygmyl4fmstibtrckzdoibsmxqypjg2aohwpsg57urqhw@5bikquw6kwew>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ofjgwiygmyl4fmstibtrckzdoibsmxqypjg2aohwpsg57urqhw@5bikquw6kwew>

On Wed, Mar 20, 2024 at 03:57:59PM -0400, Kent Overstreet wrote:
> On Wed, Mar 20, 2024 at 10:54:02PM +0800, Kuan-Wei Chiu wrote:
> > This patch series focuses on several adjustments related to heap
> > implementation. Firstly, a type-safe interface has been added to the
> > min_heap, along with the introduction of several new functions to
> > enhance its functionality. Additionally, the heap implementation for
> > bcache and bcachefs has been replaced with the generic min_heap
> > implementation from include/linux. Furthermore, several typos have been
> > corrected.
> 
> looks like something's busted:
> 
> https://evilpiepirate.org/~testdashboard/ci?branch=refactor-heap

Oh...That's horrible.
I apologize for the error in the patch I sent.

As I am relatively new to bcache and bcachefs, I would like to ask if
you have any suggestions on how I can conduct comprehensive testing
locally, similar to the CI process you use. This way, I can ensure that
patches are thoroughly tested before next submission.

Regards,
Kuan-Wei

