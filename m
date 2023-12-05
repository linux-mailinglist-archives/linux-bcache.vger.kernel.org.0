Return-Path: <linux-bcache+bounces-107-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFE2C805AA6
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 18:04:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A1C3281D35
	for <lists+linux-bcache@lfdr.de>; Tue,  5 Dec 2023 17:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85D165ED5;
	Tue,  5 Dec 2023 17:03:58 +0000 (UTC)
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CBD9A1;
	Tue,  5 Dec 2023 09:03:55 -0800 (PST)
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-58ceab7daddso2484286eaf.3;
        Tue, 05 Dec 2023 09:03:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701795835; x=1702400635;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5Kxt6CKccKyM2aD5KqaYbJ+5NRAtsSu20TdTe87tfro=;
        b=gC36X4NARMJFnoLUNZ6eIGcjEc1l5871SjthUiIspKmoaHf1kKjnlSO/V046uFgT2E
         ANpe+rE5YEEqD2ycQzEEJ2mRgqdkimd665BviZzZGLt00siu1fKb6fMq6SofmFtGR9Px
         /zZsUIDflXJhqBv7j8JhsaId5oPThrEeECQf5cm+TU/s04ZWVnfKzi3t9ivWG7FV5IV7
         HAKl0s0DEmaS9cO/6BzT6PWwXhne8jh6A1fDwzLnkdgkZjOzP56x2wDgqZCl+pc1x+lZ
         w4m5sa7rw0F01s7QLkdN9wIPpD6NKIHh+cJB34LW3DHrhW2juZF4rQu33NAJsvjscxVW
         LC8Q==
X-Gm-Message-State: AOJu0YyRYu6XQo6MkLfAFga6iBIY3nm9gjjsFU1upk6OFnZLq5EGsGF2
	MNkzx2aSUSOJ7Mqx2nFdsWg=
X-Google-Smtp-Source: AGHT+IHREsBDTR/fguPuUAOPGrQJFqdX7+L934/9nqEfo9v3T6jgbM8x1qOuTAd7fOfx1S8tYfwMzA==
X-Received: by 2002:a05:6358:6f95:b0:16e:43a1:6881 with SMTP id s21-20020a0563586f9500b0016e43a16881mr2252180rwn.26.1701795834695;
        Tue, 05 Dec 2023 09:03:54 -0800 (PST)
Received: from [172.20.2.177] (rrcs-173-197-90-226.west.biz.rr.com. [173.197.90.226])
        by smtp.gmail.com with ESMTPSA id s25-20020a639259000000b00578afd8e012sm5146562pgn.92.2023.12.05.09.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 09:03:54 -0800 (PST)
Message-ID: <189fa9b2-bcc8-4839-ac04-33a29bba9aaa@acm.org>
Date: Tue, 5 Dec 2023 09:03:48 -0800
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next RFC 01/14] block: add some bdev apis
Content-Language: en-US
To: Yu Kuai <yukuai1@huaweicloud.com>, axboe@kernel.dk, roger.pau@citrix.com,
 colyli@suse.de, kent.overstreet@gmail.com, joern@lazybastard.org,
 miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
 sth@linux.ibm.com, hoeppner@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, clm@fb.com, josef@toxicpanda.com,
 dsterba@suse.com, nico@fluxnic.net, xiang@kernel.org, chao@kernel.org,
 tytso@mit.edu, adilger.kernel@dilger.ca, agruenba@redhat.com, jack@suse.com,
 konishi.ryusuke@gmail.com, willy@infradead.org, akpm@linux-foundation.org,
 hare@suse.de, p.raghav@samsung.com
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
 linux-mtd@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-bcachefs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, gfs2@lists.linux.dev,
 linux-nilfs@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com,
 yangerkun@huawei.com
References: <20231205123728.1866699-1-yukuai1@huaweicloud.com>
 <20231205123728.1866699-2-yukuai1@huaweicloud.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231205123728.1866699-2-yukuai1@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 04:37, Yu Kuai wrote:
> +static inline u8 block_bits(struct block_device *bdev)
> +{
> +	return bdev->bd_inode->i_blkbits;
> +}

This function needs a name that's more descriptive.

Thanks,

Bart.

