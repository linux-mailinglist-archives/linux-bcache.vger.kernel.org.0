Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04580EC4F7
	for <lists+linux-bcache@lfdr.de>; Fri,  1 Nov 2019 15:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfKAOr7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 1 Nov 2019 10:47:59 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33333 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbfKAOr7 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 1 Nov 2019 10:47:59 -0400
Received: by mail-io1-f68.google.com with SMTP id n17so11192931ioa.0
        for <linux-bcache@vger.kernel.org>; Fri, 01 Nov 2019 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BeIbdkmxPYwA4T13HKBZg++DpXYrgkFvAhhSTcv15h0=;
        b=x3fu0CfLHsE/1IOqYXE9YzRQkDhk39+9EECOmh09S8L0I3z+j0NrFMWCjly4vOQpk3
         pcCK4u57bfyM7322Es9JyCAF7AnPtaYxB4CtUwOy58iXGK3kIinLJ2h0PGOlIYzt8v/r
         oMlkb8SVWQtoQiqnY0uXP4riE0mfq3jsJwjucy0iucf8ykvieX6fn5vw01lk7WqI2ous
         U6wFAaad92/uLe/9EvAt55Uf2AuHhF9Ujj/S8gzKrwhauBVH/1/6w9C8CbHP3tMJmjI0
         m1SS50aPzyulvJOqYiNKOYDX/SKVASra4B5kGCIoUbsoX9bvBJ/KOBAQP1zJNrS7e4UC
         /VvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BeIbdkmxPYwA4T13HKBZg++DpXYrgkFvAhhSTcv15h0=;
        b=olKfc+dFaLDJgDHAKV2QU70wkUoWCguqswrW3RSEEYfG/Yjnu+xayIV79at/CxxDZU
         80j4UWJPuncYbYAiHY6x+NI6zl4cKMErDF43WflVb7AqLdkfORbknOsuQ3Ca6YaBn9Py
         ITpWyRnnpa9zQGV0qPzrfgvy8rX5FA3+XjSQ7sIbSfrWNaWaTzgqyuYbfFTFYBBWCaG0
         3G6oTKS03slI9VbrQTlZaF5/4c5JFgW+xdBbO+4fSPLu3wklHi7Yzxp/sJnv2Xuzs37M
         EyaUMEHI49wJapYtHWJkW1ItWO3/i//ExdLyeD+liaJtWMreuPY5nMILL0DQwL33EEv1
         pQOQ==
X-Gm-Message-State: APjAAAVlp6tDjHSiD6cU4PuNsoFToSGt7CQmGgxe+/GTwE8UKxt3gedr
        OGptN59wKTeR/XO5X0yl+9B1VZbzeeUr5Q==
X-Google-Smtp-Source: APXvYqyhMKwJs1xFN3kgU68EyLOVs67imGeYdPZNcFQXrotVCpmsKpZr0o5GBDMpBcdir0kduiwLlw==
X-Received: by 2002:a02:998a:: with SMTP id a10mr5143185jal.99.1572619677780;
        Fri, 01 Nov 2019 07:47:57 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v18sm250452ilg.43.2019.11.01.07.47.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:47:56 -0700 (PDT)
Subject: Re: [PATCH V3] block: optimize for small block size IO
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Keith Busch <kbusch@kernel.org>, linux-bcache@vger.kernel.org
References: <20191029105125.12928-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f98f8fa3-8dc6-2316-200c-c3c4a920940e@kernel.dk>
Date:   Fri, 1 Nov 2019 08:47:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191029105125.12928-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/29/19 4:51 AM, Ming Lei wrote:
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 48e6725b32ee..737bbec9e153 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -309,6 +309,10 @@ void __blk_queue_split(struct request_queue *q, struct bio **bio,
>   				nr_segs);
>   		break;
>   	default:
> +		if (!bio_flagged(*bio, BIO_MULTI_PAGE)) {
> +			*nr_segs = 1;
> +			return;
> +		}
>   		split = blk_bio_segment_split(q, *bio, &q->bio_split, nr_segs);
>   		break;
>   	}

Can we just make that:

  	default:
		if (!bio_flagged(*bio, BIO_MULTI_PAGE)) {
			*nr_segs = 1;
			split = NULL;
		} else {
  			split = blk_bio_segment_split(q, *bio, &q->bio_split,
							nr_segs);
		}
  		break;

Otherwise this looks fine to me, and the win is palatable.

-- 
Jens Axboe

