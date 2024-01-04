Return-Path: <linux-bcache+bounces-215-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4F182477C
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 18:31:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0C7B1C241BF
	for <lists+linux-bcache@lfdr.de>; Thu,  4 Jan 2024 17:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C9B528699;
	Thu,  4 Jan 2024 17:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WQr6YuxP"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D428DB9
	for <linux-bcache@vger.kernel.org>; Thu,  4 Jan 2024 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1d426ad4433so5030155ad.0
        for <linux-bcache@vger.kernel.org>; Thu, 04 Jan 2024 09:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704389509; x=1704994309; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2qn6VAQhWQUb4CiHmq8h+Yo362Cgbx3EEBUJCdDtwc=;
        b=WQr6YuxPgGGirkeMuBYn5m87aN/cWl4KLkdmtHWAe2SMlLpElb62RkJyO5b6q3qD/o
         4sXA4EgRRRzrB7/2cb3geQBDsRz/nD7ReYUpyYB6QKuQoP6tV9r0A8BQO4vL3Q6NCRLC
         qsW/ooJr0c10Pp8kq0dWD6aZ1QHk3spJ5lCkvgSpYltKWfwbzQ27Xj1LGlTUIk/n6xPD
         nkuMM7bsulVLJCSCD3N7KLTkooYvh8EwYwbnRFtUlueEnuJjsrpkJOPtMGNyUY88s7VG
         YavHcxPLjpDsJpY/jwk78eq3MFEvR/TVt66k81sCJRsowLt8u/QGbbgfpMYKZz+KpT/p
         E7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704389509; x=1704994309;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2qn6VAQhWQUb4CiHmq8h+Yo362Cgbx3EEBUJCdDtwc=;
        b=MEdUFw7L1cALI289XQvcXuV83u/db02a4pUkIOfC9Qtj/BxzN1UpHv5mEPXZYH4DHl
         JA+8LGulOczDo0QotBDegbIsMY0eNlCu1b+YA7SMH1l5wuMADTrGd4yiKSGwV5uySMDq
         GsV3Go9NhPZ/QACqNK5XC5It6kY3wXHWX7G5OfRO/3dBCNMvI5yJseQQbazGBf5SQFQv
         DFyqtTWRAUkRvlFB7tv+6b9wzgPJuSQGr7WngFQoKhSG+2lP9aGzUDQDELsl+0XLRtzU
         BxROkQEaNiwAQ426VHiCg/qLr9qAzU/7ey+n6gQzJss647/wJ0xMxJafPjyubUtPG1fF
         0FGw==
X-Gm-Message-State: AOJu0YxqjgcAR+XiRAnySku1sAzAKcoQWMAKQrpOrg672zmRsiOFgDDH
	5imm3rrO3JnWlZFRMlfWTb+LiBSNaMnl
X-Google-Smtp-Source: AGHT+IHMC5pZFX/0Skg2KosMt2koIMu23ZQakX4wRBOCCZwE0XOW8EMW0XldZ0cn7U85d4bQM0ur4Q==
X-Received: by 2002:a17:902:f68e:b0:1d4:4483:67d4 with SMTP id l14-20020a170902f68e00b001d4448367d4mr692781plg.89.1704389508707;
        Thu, 04 Jan 2024 09:31:48 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id y22-20020a170902b49600b001d4910ff83dsm13256439plr.121.2024.01.04.09.31.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jan 2024 09:31:48 -0800 (PST)
Date: Thu, 4 Jan 2024 17:31:45 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>, Martijn Coenen <maco@android.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Christian Brauner <brauner@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, Coly Li <colyli@suse.de>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Marco Elver <elver@google.com>, Kees Cook <keescook@chromium.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-bcache@vger.kernel.org
Subject: Re: [PATCH v2 2/3] binder: Use of hlist_count_nodes()
Message-ID: <ZZbrgYTkhp_EH6Ci@google.com>
References: <20240104164937.424320-1-pierre.gondois@arm.com>
 <20240104164937.424320-3-pierre.gondois@arm.com>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240104164937.424320-3-pierre.gondois@arm.com>

On Thu, Jan 04, 2024 at 05:49:34PM +0100, Pierre Gondois wrote:
> Make use of the newly added hlist_count_nodes().
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>  drivers/android/binder.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 92128aae2d06..f9ca4d58d825 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -6077,9 +6077,7 @@ static void print_binder_node_nilocked(struct seq_file *m,
>  	struct binder_work *w;
>  	int count;
>  
> -	count = 0;
> -	hlist_for_each_entry(ref, &node->refs, node_entry)
> -		count++;
> +	count = hlist_count_nodes(&node->refs);
>  
>  	seq_printf(m, "  node %d: u%016llx c%016llx hs %d hw %d ls %d lw %d is %d iw %d tr %d",
>  		   node->debug_id, (u64)node->ptr, (u64)node->cookie,
> -- 
> 2.25.1
> 

Looks good to me!

Acked-by: Carlos Llamas <cmllamas@google.com>

