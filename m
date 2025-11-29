Return-Path: <linux-bcache+bounces-1293-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E428C93A82
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 10:03:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 1FE064E4B26
	for <lists+linux-bcache@lfdr.de>; Sat, 29 Nov 2025 09:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3F327FB1E;
	Sat, 29 Nov 2025 09:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eCQquR5g"
X-Original-To: linux-bcache@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B899427B34D
	for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764406917; cv=none; b=X0otPWqVl82SjZ1YH5D3UfWOg719Nw4Z0m33ie3ibabsl5uC+NzkWWfWci+9vR1p6Qqcby8tWmNLCiEpHgpdZVsr4kWkONOQuFTLMIflgj5s0ox9apuExi1vlJkhc6SDCpjRcrQKYa4nbwI5fe10AwTJwdjl8Daf0/IitG9BoD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764406917; c=relaxed/simple;
	bh=pDPxpgP4y7Y34S846UZ5pdageZyT3VDirSvStDnHRd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EByR372wGzATq8fzQusUMjhQ9htpPmr+gX0ZjlwEvFo3EhHO2IhhFZxJS+osLSIFHwiHMdJWsLHCVTurVUxAXmQQV7jUhrQWfLzKhsf4VyqfLaUc4Gs7qK7Bg/luoblkfHrraVCP6gBlq15Ik4kZGMl8gbVXZAKGUEcn/HQB1HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eCQquR5g; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7bab7c997eeso3137445b3a.0
        for <linux-bcache@vger.kernel.org>; Sat, 29 Nov 2025 01:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764406914; x=1765011714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=eCQquR5g2nzkSn2xhtf/misuhs+3/XAS8F89freoYMhp/QU2qz/W7KUKu01a/B+W+B
         qnt8HseNzz86ai9qT4vvsoI0a1AkF/PujnGoqDBMjIvv13WLo2vV8hSgARMExFaic8Qy
         6cHt1lezisfN6o/qaY5VGjok8CJkHHLi//N9zsORIFU07TrNviikiX0OMaeV/YlWSjUX
         yf1L068Hrtnde45bQb7zfgSePLkZQAkyF7A5MSsfY9+5Y2wv31mq+nUxc76XXG5W2Q6c
         2W7XzjtCSM7AMVBb/tne8Qf5Im1KuKZJk88r4q7+B4iR9HxlRHwoiJxREo8T/vtTDn6B
         Do/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764406914; x=1765011714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t8NoibJSiNHVArlLUK5xHvDn/GmQ96N4NjNkgGx3wcU=;
        b=r9mbgPFEH2XAKnXeGn/lSHS+mOeSY4kzBUP5RDn3zW/CQ+m3B/R08VmwhYmiAod0O9
         dbV7TuoW9HJuU/3+NBBksDEbWvTkUxGaezpEtV3NoLIFCtKj8jjFZIN/AX4dfFrL0sBF
         QUzovr4EcGz1G6JqmKsNeWc1go3SjcXdvwRodykCXfMqtuyGECBc3ko2h5Ux3bc6whcH
         kFxHwrb7/q4RUeCSu4xP0PmLGyIMqagLm1GTDJjmPv8R35OgJfEymgVdHtW3XdlSwuYD
         sIQLN9huZr5Y4z2nIMslCRB3DXkgLzgqmzcUmFv/bGoq1ANNOQhvspnKfSBLNgwRqZHD
         Qekw==
X-Forwarded-Encrypted: i=1; AJvYcCVAzC8rKT7lQCV+brQ2rGVaka4jCB83aHeAMeNw/s6P6iT2Namnv1TovkaNwnS4/fykoYOW8HjTI7tdclI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU0t4RtAjR8gudyn8uUmn8rCW6UufDExUJl8+W0HOiqJEEBcY/
	wK+mYqb/9oYhHOsCNin916HnNYEOHaST7+fpQbMznO0r9TxGGuyWE55/
X-Gm-Gg: ASbGncvyQAeeFmyxZzKM7rMvAgc83ZUH553AtVDnktnOMqfpEhmbFMPdM7JIfAO1g2D
	84BIkFk4y5Fxzlhm+5f2YzEf01vhdenQEkJh2X1h9AnlnYSQlXyD0nkr9jPQhPXbs+uBeFJaioa
	X30S2S0B5qyTk7S7W52H1fMK9lZbZoFFJukkWNp6UiQ61x6lkzisteRFWmrs/E3ugybwXJnHjAj
	xZBvw6DvjGSciqwv7ix6KZUS2RvWufaVIwjzJ+XEQuNzBIsnD0Cn7JQmgSkM5If9O781ru/lab5
	jyK+fHNeguIu3xR6cKlR3XW34hP1mH6BJWdLwoxSqcFXv13C6uuSxHLWazFSBjgvGyakqh34OTz
	1ywmP5cE6qnJYhB4L0T149RzCxNHEkLWoLbLeaNCMIPfYf+L4NV85G1V3ycS/zuoX+NsmDEBHjJ
	fIdBqG1lK8PedC0PjtvWstPSTIr7DNQdY4Vr7Y
X-Google-Smtp-Source: AGHT+IG2wahiB2PBWVfrDNRf7p52lLBDrzQQGimm/4V6gX8Dcmjw91342gxhdzWR3iErnl9Stx9Lzw==
X-Received: by 2002:a05:7022:3c84:b0:119:e569:f277 with SMTP id a92af1059eb24-11c9d864eddmr16724097c88.32.1764406914041;
        Sat, 29 Nov 2025 01:01:54 -0800 (PST)
Received: from localhost.localdomain ([104.128.72.44])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11dcae73bedsm28114394c88.0.2025.11.29.01.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 01:01:53 -0800 (PST)
From: zhangshida <starzhangzsd@gmail.com>
X-Google-Original-From: zhangshida <zhangshida@kylinos.cn>
To: Johannes.Thumshirn@wdc.com,
	hch@infradead.org,
	agruenba@redhat.com,
	ming.lei@redhat.com,
	hsiangkao@linux.alibaba.com,
	csander@purestorage.com
Cc: linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org,
	nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev,
	ntfs3@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	zhangshida@kylinos.cn,
	starzhangzsd@gmail.com
Subject: [PATCH v3 4/9] block: export bio_chain_and_submit
Date: Sat, 29 Nov 2025 17:01:17 +0800
Message-Id: <20251129090122.2457896-5-zhangshida@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251129090122.2457896-1-zhangshida@kylinos.cn>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shida Zhang <zhangshida@kylinos.cn>

Export the bio_chain_and_submit function to make it available as a
common utility. This will allow replacing repetitive bio chaining
patterns found in multiple locations throughout the codebase.

Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
---
 block/bio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/block/bio.c b/block/bio.c
index 097c1cd2054..7aa4a1d3672 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -368,6 +368,7 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new)
 	}
 	return new;
 }
+EXPORT_SYMBOL_GPL(bio_chain_and_submit);
 
 struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
 		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
-- 
2.34.1


